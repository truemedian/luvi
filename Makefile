OS:=$(shell uname -s)
ARCH:=$(shell uname -m)

################################################################################
# Default build options
################################################################################

CMAKE_BUILD_TYPE ?= Release

# Default to using the amalgamated Lua source.
# This speeds up the build at the cost of using more memory.
WITH_AMALG ?= ON
WITH_LUA_ENGINE ?= LuaJIT
WITH_SHARED_LIBLUV ?= OFF
WITH_SHARED_LIBUV ?= OFF
WITH_SHARED_LUA ?= OFF

## For regular builds

WITH_OPENSSL ?= ON
WITH_PCRE ?= ON
WITH_LPEG ?= ON
WITH_ZLIB ?= OFF

WITH_SHARED_OPENSSL ?= OFF
WITH_OPENSSL_ASM ?= OFF
WITH_SHARED_PCRE ?= OFF
WITH_SHARED_LPEG ?= OFF
WITH_SHARED_ZLIB ?= OFF

PREFIX ?= /usr/local
BINPREFIX ?= ${PREFIX}/bin

# NPROCS: Number of processors to use for parallel builds, passed as -jN to make
# GENERATOR: CMake generator to use, passed as -G"GENERATOR" to cmake
# PREFIX: Where to install luvi, defaults to /usr/local
# BINPREFIX: Where to install luvi binary, defaults to $PREFIX/bin
# EXTRA_BUILD_OPTIONS: extra options to pass to make when building
# EXTRA_CONFIGURE_FLAGS: extra options to pass to cmake when configuring
#
# Note: WITH_SHARED_LUA=ON and WITH_LUA_ENGINE=Lua is known to be very buggy.
#       This is an artifact of how incompatible PUC Lua bytecode is with
#       Different systems.
#
#       It *should* work on your system, but don't expect it to work anywhere else.
#
################################################################################

CONFIGURE_FLAGS := \
	-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
	-DWITH_AMALG=${WITH_AMALG} \
	-DWITH_LUA_ENGINE=${WITH_LUA_ENGINE} \
	-DWithSharedLibluv=${WITH_SHARED_LIBLUV} \
	-DWithSharedLibuv=${WITH_SHARED_LIBUV} \
	-DWithSharedLua=${WITH_SHARED_LUA} \

CONFIGURE_REGULAR_FLAGS := ${CONFIGURE_FLAGS} \
	-DWithOpenSSL=${WITH_OPENSSL} \
	-DWithPCRE=${WITH_PCRE} \
	-DWithLPEG=${WITH_LPEG} \
	-DWithZLIB=${WITH_ZLIB} \
	-DWithSharedOpenSSL=${WITH_SHARED_OPENSSL} \
	-DWithOpenSSLASM=${WITH_OPENSSL_ASM} \
	-DWithSharedPCRE=${WITH_SHARED_PCRE} \
	-DWithSharedLPEG=${WITH_SHARED_LPEG} \
	-DWithSharedZLIB=${WITH_SHARED_ZLIB} \

ifdef GENERATOR
	CONFIGURE_FLAGS+= -G"${GENERATOR}"
endif

ifndef NPROCS
ifeq (${OS},Linux)
	NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)
else ifeq (${OS},Darwin)
	NPROCS:=$(shell sysctl hw.ncpu | awk '{print $$2}')
endif
endif

ifdef NPROCS
  BUILD_OPTIONS:=-j${NPROCS}
endif

# This does the actual build and configures as default flavor is there is no build folder.
luvi: build
	cmake --build build -- ${BUILD_OPTIONS} ${EXTRA_BUILD_OPTIONS}

build:
	@echo "Please run 'tiny' or 'regular' make target first to configure"

# Configure the build with minimal dependencies
tiny: deps/luv/CMakeLists.txt
	cmake -H. -Bbuild ${CONFIGURE_FLAGS} ${EXTRA_CONFIGURE_FLAGS}

# Configure the build with openssl, pcre and lpeg
regular: deps/luv/CMakeLists.txt
	cmake -H. -Bbuild ${CONFIGURE_REGULAR_FLAGS} ${EXTRA_CONFIGURE_FLAGS}

# In case the user forgot to pull in submodules, grab them.
deps/luv/CMakeLists.txt:
	git submodule update --init --recursive

clean:
	rm -rf build test.bin

reset:
	git submodule update --init --recursive && \
	git clean -f -d && \
	git checkout .

install: luvi
	install -p build/luvi ${BINPREFIX}/luvi

uninstall:
	rm -f ${BINPREFIX}/luvi

test: luvi
	rm -f test.bin
	build/luvi samples/test.app -- 1 2 3 4
	build/luvi samples/test.app -o test.bin
	./test.bin 1 2 3 4
	rm -f test.bin
