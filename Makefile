XCFLAGS=
#XCFLAGS+=-DLUAJIT_DISABLE_JIT
XCFLAGS+=-DLUAJIT_ENABLE_LUA52COMPAT
#XCFLAGS+=-DLUA_USE_APICHECK
export XCFLAGS
# verbose build
export Q=
MAKEFLAGS+=-e

CFLAGS+=-Iluv/libuv/include -Izlib -Izlib/contrib/minizip -Iluajit-2.0/src \
	-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 \
	-O3 -Wformat -Wall -pedantic -std=gnu99 -DLUAJIT_ENABLE_LUA52COMPAT

uname_S=$(shell uname -s)
ifeq (Darwin, $(uname_S))
	LDFLAGS+=-framework CoreServices -pagezero_size 10000 -image_base 100000000
else
	LDFLAGS=-lpthread -lm -ldl -Wl,-E -lrt
endif

SOURCE_FILES=\
	src/main.c \
	src/luvi.c \
	src/tinfl.c \
	luv/src/dns.c \
	luv/src/fs.c \
	luv/src/handle.c \
	luv/src/luv.c \
	luv/src/luv.h \
	luv/src/misc.c \
	luv/src/pipe.c \
	luv/src/process.c \
	luv/src/stream.c \
	luv/src/tcp.c \
	luv/src/timer.c \
	luv/src/tty.c \
	luv/src/util.c

DEPS =\
	init.lua.o \
	zipreader.lua.o \
	luajit-2.0/src/libluajit.a \
	luv/libuv/libuv.a

all: luvi
	make -C samples

gyp:
	# replace with configure
	tools/gyp/gyp --depth=$$PWD -D target_arch=x64 -Goutput_dir=$$PWD/out --generator-output $$PWD/out -f make -I common.gypi -D library=static_library
	$(MAKE) -C out

luv/libuv/libuv.a:
	$(MAKE) -C luv/libuv

luajit-2.0/src/libluajit.a:
	$(MAKE) -C luajit-2.0


%.lua.o: src/lua/%.lua luajit-2.0/src/libluajit.a
	cd luajit-2.0/src && ./luajit -bg ../../$< ../../$@ && cd ../..

luvi.o: ${SOURCE_FILES}
	$(CC) -c src/main.c ${CFLAGS} -o luvi.o

luvi: luvi.o ${DEPS}
	$(CC) luvi.o ${DEPS} ${LDFLAGS} -o $@

clean-all: clean
	$(MAKE) -C luajit-2.0 clean
	$(MAKE) -C luv clean
	$(MAKE) -C luv/libuv clean

clean:
	rm -f luvi *.o *.lua.c
	make -C samples clean
