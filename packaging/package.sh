failed=
function delete() {
    files=$(ls -1A $1 2>/dev/null | tr '\n' ' ')
    if [ ! -z "$files" ]; then
        echo "delete $files"
        rm -rf $files
    else
        failed="$failed $1"
    fi
}

delete .git/          # git tracking information
delete .gitattributes # git file attributes
delete .github/       # github actions workflows
delete .gitignore     # git ignore rules
delete .gitmodules    # git submodule remotes
delete lgtm.yml       # LGTM configuration
delete packaging/     # packaging scripts

delete deps/lpeg/.git     # git tracking information
delete deps/lpeg/*.gif    # documentation
delete deps/lpeg/*.html   # documentation
delete deps/lpeg/makefile # build system, vendored into cmake
delete deps/lpeg/test.lua # test script

delete deps/lrexlib/.git          # git tracking information
delete deps/lrexlib/.gitignore    # git ignore rules
delete deps/lrexlib/*.lua         # rockspec generation
delete deps/lrexlib/ChangeLog.old # old changelog
delete deps/lrexlib/doc/          # documentation
delete deps/lrexlib/Makefile      # build system, vendored into cmake
delete deps/lrexlib/test/         # test scripts
delete deps/lrexlib/windows/      # windows build scripts, vendored into cmake

delete deps/lua-openssl/.git                     # git tracking information
delete deps/lua-openssl/.gitattributes           # git file attributes
delete deps/lua-openssl/.github/                 # github actions workflows
delete deps/lua-openssl/.gitignore               # git ignore rules
delete deps/lua-openssl/.gitmodules              # git submodule remotes
delete deps/lua-openssl/.luacheckrc              # luacheck configuration
delete deps/lua-openssl/*.rockspec               # luarocks configuration
delete deps/lua-openssl/appveyor.yml             # appveyor configuration
delete deps/lua-openssl/cmake                    # cmake modules, vendored into cmake
delete deps/lua-openssl/CMakeLists.txt           # build system, vendored into cmake
delete deps/lua-openssl/config.win               # build system, vendored into cmake
delete deps/lua-openssl/deps/auxiliar/.git/      # git tracking information
delete deps/lua-openssl/deps/auxiliar/.gitignore # git ignore rules
delete deps/lua-openssl/deps/lua-compat          # vendored dependency, already present in luv
delete deps/lua-openssl/Makefile                 # build system, vendored into cmake
delete deps/lua-openssl/Makefile.win             # build system, vendored into cmake
delete deps/lua-openssl/src/config.ld            # ldoc configuration
delete deps/lua-openssl/test                     # test scripts

delete deps/lua-zlib/.git           # git tracking information
delete deps/lua-zlib/.gitattributes # git file attributes
delete deps/lua-zlib/.github        # github actions workflows
delete deps/lua-zlib/.luacheckrc    # luacheck configuration
delete deps/lua-zlib/*.gz           # test data
delete deps/lua-zlib/*.lua          # test scripts
delete deps/lua-zlib/*.out          # test data
delete deps/lua-zlib/*.rockspec     # luarocks configuration
delete deps/lua-zlib/cmake          # cmake modules, vendored into cmake
delete deps/lua-zlib/CMakeLists.txt # build system, vendored into cmake
delete deps/lua-zlib/Makefile       # build system, vendored into cmake
delete deps/lua-zlib/rockspecs      # luarocks configuration

delete deps/zlib/.git             # git tracking information
delete deps/zlib/.github          # github actions workflows
delete deps/zlib/.gitignore       # git ignore rules
delete deps/zlib/amiga            # amiga build scripts
delete deps/zlib/configure        # build system, not used
delete deps/zlib/contrib          # extra utilities
delete deps/zlib/doc              # documentation
delete deps/zlib/examples         # example code
delete deps/zlib/FAQ              # documentation
delete deps/zlib/INDEX            # documentation
delete deps/zlib/make_vms.com     # vms build script
delete deps/zlib/Makefile         # build system, not used
delete deps/zlib/Makefile.in      # build system data
delete deps/zlib/msdos            # msdos build scripts
delete deps/zlib/nintendods       # nintendods build scripts
delete deps/zlib/old              # old build scripts
delete deps/zlib/os400            # os400 build scripts
delete deps/zlib/qnx              # qnx build scripts
delete deps/zlib/test             # test scripts
delete deps/zlib/treebuild.xml    # build system data
delete deps/zlib/watcom           # watcom build scripts
delete deps/zlib/win32            # win32 build scripts
delete deps/zlib/zconf.h.in       # build system data
delete deps/zlib/zlib.3           # documentation
delete deps/zlib/zlib.3.pdf       # documentation
delete deps/zlib/zlib.pc.cmakein  # build system data
delete deps/zlib/zlib.pc.in       # build system data

delete deps/luv/.git          # git tracking information
delete deps/luv/.ci           # github actions workflows
delete deps/luv/.github       # github actions workflows
delete deps/luv/examples      # example code
delete deps/luv/lib           # test scripts
delete deps/luv/rockspecs     # luarocks configuration
delete deps/luv/test          # test scripts
delete deps/luv/.clang-format # clang format configuration
delete deps/luv/.clangd       # clangd configuration
delete deps/luv/.gitignore    # git ignore rules
delete deps/luv/.gitmodules   # git submodule remotes
delete deps/luv/.editorconfig # editor configuration
delete deps/luv/Makefile      # build system, not used
delete deps/luv/msvcbuild.bat # build system, not used
delete deps/luv/libluv.pc.in  # build system data
delete deps/luv/docs.md       # documentation
delete deps/luv/*.rockspec    # luarocks configuration
delete deps/luv/appveyor.yml  # appveyor configuration

if [ ! -z "$failed" ]; then
    echo "Failed to delete the following directories: $failed"
    exit 1
fi