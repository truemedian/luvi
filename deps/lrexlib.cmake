include(deps/pcre.cmake)

set(LREXLIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/lrexlib" CACHE PATH "Path to lrexlib")

add_library(lrexlib STATIC
  ${LREXLIB_DIR}/src/common.c
  ${LREXLIB_DIR}/src/pcre/lpcre.c
  ${LREXLIB_DIR}/src/pcre/lpcre_f.c
)

target_include_directories(lrexlib PUBLIC ${PCRE_INCLUDE_DIR})
target_link_libraries(lrexlib ${PCRE_LIBRARIES})
target_compile_definitions(lrexlib PRIVATE
  LUA_COMPAT_APIINTCASTS
  VERSION="2.8.0"
  PCRE_STATIC)

list(APPEND EXTRA_LIBS lrexlib ${PCRE_LIBRARIES})
list(APPEND EXTRA_DEFINITIONS WITH_PCRE=1)
