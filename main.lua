local AddonName, AddonTable = ...

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
local ItemBonus = LibStub("AceAddon-3.0"):NewAddon("AdiBags_ItemBonus")

local currentExpansionIndex = GetNumExpansions() - 1

function ItemBonus:GetOptions()
    return {
        Speed = {
            name = "Speed",
            desc = 'Speed',
            type = 'toggle',
            order = 70,
        },
        Leech = {
            name = "Leech",
            desc = 'Leech',
            type = 'toggle',
            order = 79,
        },
        Indestructable = {
            name = "Indestructable",
            desc = 'Indestructable',
            type = 'toggle',
            order = 79,
        },
        Sockets = {
            name = "Sockets",
            desc = 'Sockets',
            type = 'toggle',
            order = 79,
        }
    }
end

function ItemBonus:GetProfile()
    return {
        Speed = true,
        Leech = true,
        Indestructable = true,
        Sockets = true
    }
end

function ItemBonus:GetDefaultCategories()
    return {
        ["Speed"] = "Speed",
        ["Leech"] = "Leech",
        ["Indestructable"] = "Indestructable",
        ["Sockets"] = "Sockets",
    }
end

function ItemBonus:Dump(str, obj)
    if ViragDevTool_AddData then
        ViragDevTool_AddData(obj, str)
    end
end

function ItemBonus:IsCurrentExpansion(item)
    -- https://wow.gamepedia.com/API_GetItemInfo
    local _, _, _, _, _, _, _, _, _, _, _, _, _, _, expacID, _, _ = GetItemInfo(item)
    -- BfA = 8.x = expac 7
    return expacID == currentExpansionIndex
end

function ItemBonus:DefaultFilter(slotData, module)
    local speedMod          = "ITEM_MOD_CR_SPEED_SHORT"
    local leechMod          = "ITEM_MOD_CR_LIFESTEAL_SHORT"
    local hasteMod          = "ITEM_MOD_HASTE_RATING_SHORT"
    local intMod            = "ITEM_MOD_INTELLECT_SHORT"
    local masteryMod        = "ITEM_MOD_MASTERY_RATING_SHORT"
    local versatilityMod    = "ITEM_MOD_VERSATILITY"
    local staminaMod        = "ITEM_MOD_STAMINA_SHORT"
    local socketMod         = "EMPTY_SOCKET_PRISMATIC"
    local indestructableMod = "ITEM_MOD_CR_STURDINESS_SHORT"

    local itemStats = GetItemStats(slotData.link)

    local isCurrentExpansion = ItemBonus:IsCurrentExpansion(slotData.itemId)

    if (isCurrentExpansion) then
        if (itemStats ~= nil) then
            if (itemStats[leechMod] ~= nil) then
                return 'Leech'
            end
            if (itemStats[speedMod] ~= nil) then
                return 'Speed'
            end
            if (itemStats[socketMod] ~= nil) then
                return 'Socket'
            end
            if (itemStats[indestructableMod] ~= nil) then
                return 'Indestructable'
            end
        end
    end
end

local module = {
    ["name"] = "ItemBonuses",
    ["categories"] = ItemBonus:GetDefaultCategories(),
    ["namespace"] = "ItemBonuses",
    ["description"] = "Items with Bonus Affixes"
}

local filter = AdiBags:RegisterFilter(module.namespace, 90)

function filter:Filter(slotData)
    return ItemBonus:DefaultFilter(slotData, module)
end

function filter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace(module.namespace, {
        profile = ItemBonus:GetProfile()
    })
end

function filter:GetOptions()
    return ItemBonus:GetOptions(), AdiBags:GetOptionHandler(self, true)
end
