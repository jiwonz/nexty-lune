--!strict

local ArgParse = require("../submodules/argparse")
local NextyLune = require(".")

local main = ArgParse("nexty-lune")
local start = main:command("start", "Start a server")
start:option("--port", "port")
start:option("--project", "project")
start:action(function(args)
	NextyLune.start(args.project, tonumber(args.port) or 3000)
end)
main:parse()
