local AddonName, AddonTable = ...

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
local ItemBonus = LibStub("AceAddon-3.0"):NewAddon("AdiBags_ItemBonus")

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
        }
    }
end

function ItemBonus:GetProfile()
    return {
        Speed = true,
        Leech = true
    }
end

function ItemBonus:GetDefaultCategories()
    return {
        ["Speed"] = "Speed",
        ["Leech"] = "Leech"
    }
end

function ItemBonus:Dump(str, obj)
    if ViragDevTool_AddData then
        ViragDevTool_AddData(obj, str)
    end
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

    -- DEBUG, dump out specific item id's
    -- if (tonumber(slotData.itemId) == 124347) then
    --     ItemBonus:Dump('itemstats', itemStats)
    -- end

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

        -- Technically an item could have multiple stats, but for now lets do first come first served
    -- TODO: If Item has bonus id, add to relevent filter
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
