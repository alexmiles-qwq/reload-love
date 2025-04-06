local dialogues = {}
dialogues.d = {}                -- Actual dialogues table


--[[ 

    dialoguename    - Name of dialogue.
        who         - Character
        text        - Content
    choisestable    - Table of choises and dialogues or functions after specific choises

]]
function dialogues:AddDialogue(dialoguename, who, text, choisestable) 
    assert(dialoguename, "dialoguename cannot be nil!")
    assert(text, "Text cannot be empty!")

    local Character = who or "Unknown"


    
    local tempTable = {}

    if dialogues.d[dialoguename] then return end


    dialogues.d[dialoguename] = tempTable
    return
end

function dialogues:RemoveDialogue(name)
    if self.d[name] then self.d[name] = nil end
end


return dialogues