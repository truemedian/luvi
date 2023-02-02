-- This runs `make regular` with all possible combinations of defines and checks if it succeeds
-- This is currently 3888 invocations
--
-- This script expects:
-- - an environment that can build luvi using the Makefile
-- - Lua and Luajit (and their libraries)
-- - Libluv (the library, not the module)
-- - Libuv
-- - openssl
-- - pcre
-- - zlib

local matrix = {""}

local function addDefineToMatrix(name, values, requires)
    local new_matrix = {}

    for _, old_value in ipairs(matrix) do
        if requires and string.find(old_value, requires, 1, true) or not requires then
            for _, value in ipairs(values) do
                table.insert(new_matrix, old_value .. " " .. name .. "=" .. value)
            end
        else
            table.insert(new_matrix, old_value)
        end
    end

    matrix = new_matrix
end

addDefineToMatrix("CMAKE_BUILD_TYPE", { "Release", "RelWithDebInfo", "Debug" })
addDefineToMatrix("WITH_AMALG", { "ON", "OFF" })
addDefineToMatrix("WITH_SHARED_LIBLUV", { "ON", "OFF" })
addDefineToMatrix("WITH_SHARED_LIBUV", { "ON", "OFF" }, "WITH_SHARED_LIBLUV=OFF")
addDefineToMatrix("WITH_SHARED_LIBLUA", { "ON", "OFF" }, "WITH_SHARED_LIBLUV=OFF")
-- Shared libluv is usually only luajit, so we don't test it with lua
addDefineToMatrix("WITH_LUA_ENGINE", { "Lua", "LuaJIT" }, "WITH_SHARED_LIBLUV=OFF")

addDefineToMatrix("WITH_OPENSSL", { "ON", "OFF" })
addDefineToMatrix("WITH_PCRE", { "ON", "OFF" })
addDefineToMatrix("WITH_LPEG", { "ON", "OFF" })
addDefineToMatrix("WITH_ZLIB", { "ON", "OFF" })

addDefineToMatrix("WITH_SHARED_OPENSSL", { "ON", "OFF" }, "WITH_OPENSSL=ON")
addDefineToMatrix("WITH_OPENSSL_ASM", { "ON", "OFF" }, "WITH_SHARED_OPENSSL=OFF")
addDefineToMatrix("WITH_SHARED_PCRE", { "ON", "OFF" }, "WITH_PCRE=ON")
addDefineToMatrix("WITH_SHARED_ZLIB", { "ON", "OFF" }, "WITH_ZLIB=ON")

os.execute("mkdir -p logs")
for i, value in ipairs(matrix) do
    os.execute("make clean >/dev/null 2>&1")

    io.write(i .. " / " .. #matrix .. "... ")
    io.flush()

    local _, _, configure = os.execute(string.format("make regular %s >logs/%d.configure.log 2>&1", value, i))
    if configure == 0 then
        local _, _, build = os.execute(string.format("make >logs/%d.build.log 2>&1", i))
        if build == 0 then
            local _, _, test = os.execute(string.format("make test >logs/%d.test.log 2>&1", i))
            if test == 0 then
                os.execute(string.format("rm logs/%d.*.log", i))

                print("Success")
            else
                print("Failed")
            end
        else
            print("Failed")
        end
    else
        print("Failed")
    end
end