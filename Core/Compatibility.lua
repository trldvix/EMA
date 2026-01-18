-- ================================================================================ --
--				EMA - ( Ebony's MultiBoxing Assistant )    							--
--				Current Author: Jennifer Cally (Ebony)								--
-- ================================================================================ --

-- Compatibility layer to handle API changes in WoW 10.0+ / Classic Anniversary

-- IsAddOnLoaded
if not IsAddOnLoaded and C_AddOns and C_AddOns.IsAddOnLoaded then
    _G.IsAddOnLoaded = C_AddOns.IsAddOnLoaded
end

-- GetAddOnMetadata
if not GetAddOnMetadata and C_AddOns and C_AddOns.GetAddOnMetadata then
    _G.GetAddOnMetadata = C_AddOns.GetAddOnMetadata
end

-- Container API
if C_Container then
    _G.GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
    _G.GetContainerNumSlots = C_Container.GetContainerNumSlots
    _G.GetContainerItemInfo = function(bagID, slotID)
        local info = C_Container.GetContainerItemInfo(bagID, slotID)
        if info then
            return info.iconFileID, info.stackCount, info.isLocked, info.quality, info.isReadable, info.hasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound
        end
        return nil
    end
    _G.GetContainerItemLink = C_Container.GetContainerItemLink
    _G.GetContainerItemID = C_Container.GetContainerItemID
    _G.GetContainerItemCooldown = C_Container.GetContainerItemCooldown
    _G.PickupContainerItem = C_Container.PickupContainerItem
    _G.UseContainerItem = C_Container.UseContainerItem
    _G.PutItemInBag = C_Container.PutItemInBag
    _G.PutItemInBackpack = C_Container.PutItemInBackpack
end

-- Quest/Gossip API
if C_GossipInfo then
    if not _G.SelectGossipOption then 
        _G.SelectGossipOption = C_GossipInfo.SelectOption or C_GossipInfo.SelectOptionByIndex
    end
    if not _G.SelectGossipActiveQuest then _G.SelectGossipActiveQuest = C_GossipInfo.SelectActiveQuest end
    if not _G.SelectGossipAvailableQuest then _G.SelectGossipAvailableQuest = C_GossipInfo.SelectAvailableQuest end
end

if C_QuestLog then
    if not _G.AcceptQuest then _G.AcceptQuest = C_QuestLog.AcceptQuest end
    if not _G.CompleteQuest then _G.CompleteQuest = C_QuestLog.CompleteQuest end
    if not _G.AbandonQuest then _G.AbandonQuest = C_QuestLog.AbandonQuest end
    if not _G.GetQuestReward then _G.GetQuestReward = C_QuestLog.GetQuestReward end
end

-- SelectActiveQuest / SelectAvailableQuest fallbacks
if not _G.SelectActiveQuest and _G.SelectGossipActiveQuest then _G.SelectActiveQuest = _G.SelectGossipActiveQuest end
if not _G.SelectAvailableQuest and _G.SelectGossipAvailableQuest then _G.SelectAvailableQuest = _G.SelectGossipAvailableQuest end


-- Fix for Font issues (fallback to a standard WoW font if LSU fails)
local function SafeSetFont(fontObj, fontPath, fontSize, fontFlags)
    if not fontPath or fontPath == "" then
        fontPath = [[Fonts\FRIZQT__.TTF]]
    end
    pcall(function() 
        fontObj:SetFont(fontPath, fontSize or 12, fontFlags or "")
    end)
end
_G.EMA_SafeSetFont = SafeSetFont

-- Fix for WrapScript issue in LibActionButton
-- If WrapScript is missing, we might be in a client where secure handlers changed
-- We'll try to find where it went or just provide a no-op to prevent crashes if it's not critical
-- However, WrapScript IS critical for some things, but usually the frames SHOULD have it.
-- Global Bag Slots constant for all versions
_G.EMA_NUM_BAG_SLOTS = NUM_BAG_SLOTS
if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or (C_Container ~= nil) then
    _G.EMA_NUM_BAG_SLOTS = 5
end
