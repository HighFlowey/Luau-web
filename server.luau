local net = require("@lune/net")
local fs = require("@lune/fs")

local app = {}
local app_mt = {
    __index = app,
}

type HttpMethod = "DELETE"
| "GET"
| "HEAD"
| "OPTIONS"
| "PATCH"
| "POST"
| "PUT"

type Listener = {
    path: string,
    method: HttpMethod,
    callback: (req: net.ServeRequest) -> net.ServeResponse?,
}

type App = typeof(setmetatable({
    port = 0000,
}, app_mt))

function app.init(self: App)
    self._listeners = {}

    net.serve(self.port, function(req)
        for _, v: Listener in self._listeners do
            if v.path ~= req.path then continue end
            if v.method ~= req.method then continue end

            local response = v.callback(req)
            if response then
                return response
            end
        end

        return {}
    end)

    return self
end

function app.addListener(self: App, listener: Listener)
    table.insert(self._listeners, listener)
end

function app.addFile(self: App, path: string, file_path: string)
    table.insert(self._listeners, {
        path = path,
        method = "GET",
        callback = function(req)
            return {
                body = fs.readFile(file_path),
            }
        end
    }:: Listener)
end

local module = {}

function module.createApp(port: number): App
    return setmetatable({
        port = port,
    }, app_mt):init()
end

return module
