local logger = {}
logger.OnLoadMessage = false
logger.initTime = os.clock()

function logger.log(text, prefix) -- add prefix later
    local time = os.clock() - logger.initTime
    os.execute("echo ["..tostring(time).."]: " .. text .. " >> log.log")
end

if logger.OnLoadMessage then
    logger.log("Session started!")
end

return logger