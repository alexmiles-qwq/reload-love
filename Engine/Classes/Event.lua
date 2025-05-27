local Event = {}
Event.__index = Event

function Event:new()
    local o = {} 
    setmetatable(o, self) 

    o._listeners = {} 
    o.Name = "Event"  

    return o
end

function Event:Connect(callback)
    assert(type(callback) == "function", "Callback must be a function")

    local connection = {}
    connection.Connected = true
    connection.Event = self 

    function connection:Disconnect()
        if not self.Connected then return end 
        
        self.Connected = false
      
        for i, conn in ipairs(connection.Event._listeners) do
            if conn == connection then
                table.remove(connection.Event._listeners, i)
                break
            end
        end
    end

    function connection:_fire(...)
        if self.Connected then 
            callback(...)
        end
    end

    table.insert(self._listeners, connection)

    return connection
end

function Event:Fire(...)

    local listeners_copy = {}
    for _, conn in ipairs(self._listeners) do
        table.insert(listeners_copy, conn)
    end

    for _, conn in ipairs(listeners_copy) do
     
        if conn.Connected then
            conn:_fire(...)
        end
    end
end

return Event