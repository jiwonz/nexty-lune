local Net = require("@lune/net")
local FS = require("@lune/fs")
local ArgParse = require("submodules/argparse")
local LuauPath = require("packages/luau-path/src")

local main = ArgParse("nexty-lune")
local dev = main:command("dev", "Run a dev server")
dev:option("--port", "port")
dev:option("--project", "project")
dev:action(function(args)
    local projectPath = LuauPath.Path.from(args.project or "/")
    local appPath = projectPath:join("app")
    local port = tonumber(args.port or "3000")
    local routers = {} :: {
        [string]: (Net.ServeRequest) -> ()
    }
    Net.serve(port, function(req)
        print(req.path, req.method)
        return routers[req.path][req.method](req)
    end)

    local function processDir(path: LuauPath.Path, routerPath: string?)
        local routerPath = routerPath or "/"
        for _, fileName in FS.readDir(path:toString()) do
            
            local childPath = path:join(fileName) :: LuauPath.Path
            if FS.isDir(childPath:toString()) then
                processDir(path, routerPath .. childPath:fileStem())
            elseif FS.isFile(childPath:toString()) then
                local ext = childPath:extension()
                local name = childPath:fileStem()
                print(ext, name)
                if name == "router" and (ext == "luau" or ext == "lua") then
                    routers[routerPath] = require(childPath:toString():sub(1, -#ext - 2))
                end
            end
        end    
    end
    processDir(appPath)
    print("registered routers:", routers)
end)
local start = main:command("start", "Start a server")
start:option("--port", "port")
start:option("--project", "project")
start:action(function()

end)
main:parse()
