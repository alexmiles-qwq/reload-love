local utils = {}

function utils.FindValueInTable(tbl, val)
    for i, value in pairs(tbl) do
        if value == val then return true end
    end

    return false
end

return utils