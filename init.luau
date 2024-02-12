local server = require("server")

local numbers = 0
local app = server.createApp(3030)
app:addFile("/", "./public/index.html")
app:addFile("/renderer.js", "./public/renderer.js")
app:addFile("/styles.css", "./public/styles.css")
app:addListener({
	path = "/number",
	method = "GET",
	callback = function(req)
		if req.headers.action == "increase" then
			numbers += 1
		end

		return {
			body = numbers,
		}
	end
})

-- if req.method == "GET" then
-- 	local possible_file_path = "./public" .. req.path
-- 	local path_exists, path_is_file = pcall(fs.isFile, possible_file_path)
	
-- 	if path_exists and path_is_file then
-- 		return {
-- 			body = fs.readFile(possible_file_path)
-- 		}
-- 	end
-- end
