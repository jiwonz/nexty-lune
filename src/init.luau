--!strict

local Net = require("@lune/net")
local FS = require("@lune/fs")
local LuauPath = require("@pkg/luau-path")
local NextyLune = {}

--// $Types
type Route = {
	router: {
		[string]: (Net.ServeRequest) -> (Net.ServeResponse)
	},
	["not-found"]: nil
}

function NextyLune.start(projectPath: string, port: number)
	local projectDirectory = LuauPath.Path.from(projectPath)
	local appDirectory = projectDirectory:join("app")
	local app = {} :: {
		[string]: Route
	}

	Net.serve(port, function(req)
		print(req.path, req.method)
		return app[req.path].router[req.method](req)
	end)

	local function processDir(path: LuauPath.Path, routePath: string)
		for _, fileName in FS.readDir(path:toString()) do
			local childPath = path:join(fileName) :: LuauPath.Path
			if FS.isDir(childPath:toString()) then
				local stem = childPath:fileStem()
				if stem then
					processDir(path, routePath .. stem)
				end
			elseif FS.isFile(childPath:toString()) then
				local ext = childPath:extension()
				local name = childPath:fileStem()
				if name == "router" and (ext == "luau" or ext == "lua") then
					local route = app[routePath]
					if not route then
						route = {} :: Route
						app[routePath] = route
					end
					route.router = require(childPath:toString():sub(1, -#ext - 2)) :: any
				end
			end
		end
	end
	processDir(appDirectory, "/")
	print("registered routers:", app)
end

return NextyLune
