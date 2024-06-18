if (WithSharedOpenSSL)
  find_package(OpenSSL REQUIRED)

  message("Enabling Shared OpenSSL")
  message("OPENSSL_INCLUDE_DIR: ${OPENSSL_INCLUDE_DIR}")
  message("OPENSSL_LIBRARIES: ${OPENSSL_LIBRARIES}")
else (WithSharedOpenSSL)
  message("Enabling Static OpenSSL")
  include(ExternalProject)

  set(OPENSSL_CONFIG_OPTIONS no-unit-test no-shared no-stdio no-idea no-mdc2 no-rc5 --prefix=${CMAKE_BINARY_DIR})
  if(WithOpenSSLASM)
    enable_language(ASM)
  else()
    set(OPENSSL_CONFIG_OPTIONS no-asm ${OPENSSL_CONFIG_OPTIONS})
  endif()

  if(WIN32)
    set(OPENSSL_CONFIGURE_TARGET VC-WIN32)
    if("${CMAKE_GENERATOR_PLATFORM}" MATCHES "x64")
      set(OPENSSL_CONFIGURE_TARGET VC-WIN64A)
    endif()
    set(OPENSSL_BUILD_COMMAND nmake)
  else()
    set(OPENSSL_CONFIGURE_TARGET)
    set(OPENSSL_BUILD_COMMAND make $ENV{MAKEFLAGS})
  endif()

  ExternalProject_Add(openssl
    PREFIX            openssl
    URL               https://www.openssl.org/source/openssl-3.0.14.tar.gz
    URL_HASH          SHA256=eeca035d4dd4e84fc25846d952da6297484afa0650a6f84c682e39df3a4123ca
    LOG_BUILD         ON
    BUILD_IN_SOURCE   YES
    BUILD_COMMAND     ${OPENSSL_BUILD_COMMAND}
    CONFIGURE_COMMAND perl Configure ${OPENSSL_CONFIGURE_TARGET} ${OPENSSL_CONFIG_OPTIONS}
    INSTALL_COMMAND   ""
    TEST_COMMAND      ""
    DOWNLOAD_EXTRACT_TIMESTAMP ON
  )

  set(OPENSSL_ROOT_DIR ${CMAKE_BINARY_DIR}/openssl/src/openssl)

  if(WIN32)
    set(OPENSSL_LIB_CRYPTO ${OPENSSL_ROOT_DIR}/libcrypto.lib)
    set(OPENSSL_LIB_SSL ${OPENSSL_ROOT_DIR}/libssl.lib)
  else()
    set(OPENSSL_LIB_CRYPTO ${OPENSSL_ROOT_DIR}/libcrypto.a)
    set(OPENSSL_LIB_SSL ${OPENSSL_ROOT_DIR}/libssl.a)
  endif()

  add_library(openssl_ssl STATIC IMPORTED)
  set_target_properties(openssl_ssl PROPERTIES IMPORTED_LOCATION ${OPENSSL_LIB_SSL})

  add_library(openssl_crypto STATIC IMPORTED)
  set_target_properties(openssl_crypto PROPERTIES IMPORTED_LOCATION ${OPENSSL_LIB_CRYPTO})

  set(OPENSSL_INCLUDE_DIR ${OPENSSL_ROOT_DIR}/include)
  set(OPENSSL_LIBRARIES openssl_ssl openssl_crypto)
endif (WithSharedOpenSSL)
