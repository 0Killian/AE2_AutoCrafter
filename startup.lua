-- [[
-- An Applied Energistics 2 Auto Crafting System
-- Author: Killian Bellouard
--
-- This script is a CC:Tweaked program that makes sure a configurable
-- amount of items are always available in the ME system.
-- ]]

-- [======= CONFIGURATION =======]
-- The name of the controller to use
local CONTROLLER_NAME = "appliedenergistics2:controller_1"

-- The path to the file where the needed items are stored
local ITEMS_FILE = "needed_items.txt"

-- [======= LOCALS =======]
local controller = peripheral.wrap(CONTROLLER_NAME) --[[@as AE2Controller]]
local craftingQueue = {} --[[@type table<string, { task: AE2CraftingTask, count: number }>]]

-- [======= FUNCTIONS =======]

-- Read the needed items from the file
---@return table<string, number>
local function readNeededItems()
	local file = fs.open(ITEMS_FILE, "r")
	if file == nil then
		error("Could not open file: " .. ITEMS_FILE)
	end

	local items = {}

	while true do
		local line = file.readLine()
		if line == nil then
			break
		end
		local parts = string.gmatch(line, "%S+")
		local name = parts()
		local count = tonumber(parts())
		items[name] = count
	end

	file.close()
	return items
end

-- Find an item in the network
---@param name string|table The name of the item to find
---@return AE2Item|nil, AE2ItemDetails|nil The item and its details, or nil if not found
local function findItem(name, avlItems)
	local items = avlItems or controller.listAvailableItems()

	for _, item in ipairs(items) do
		if item.name == name then
			return item, controller.findItem(name)
		end
	end

	return nil, nil
end

-- Get the items that are missing from the network
---@param neededItems table<string, number> The items that are needed
---@return table<string, { item: AE2Item, details: AE2ItemDetails, missingCount: number }>
local function getMissingItems(neededItems)
	local missingItems = {}

	for name, count in pairs(neededItems) do
		local item, details = findItem(name)
		local craftingQueueItem = craftingQueue[name]
		local avlCount = (item and item.count or 0) + (craftingQueueItem and craftingQueueItem.count or 0)

		if avlCount < count then
			missingItems[name] = {
				item = item,
				details = details,
				missingCount = count - avlCount,
			}
		end
	end

	return missingItems
end

-- Craft the missing items
---@param missingItems table<string, { item: AE2Item, details: AE2ItemDetails, missingCount: number }>
local function craftMissingItems(missingItems)
	for name, missingItem in pairs(missingItems) do
		local item = missingItem.item
		local details = missingItem.details
		local missingCount = missingItem.missingCount

		if item == nil or not item.isCraftable then
			print("Item is not craftable: " .. name)
			return
		end

		local craftingTask = details.craft(missingCount)
		craftingQueue[name] = {
			task = craftingTask,
			count = missingCount,
		}
	end
end

-- Process the crafting queue, removing finished tasks
local function processCraftingQueue()
	for name, craftingQueueItem in pairs(craftingQueue) do
		local task = craftingQueueItem.task
		if task.isFinished() or task.isCanceled() then
			print("Crafting task finished: " .. name)
			craftingQueue[name] = nil
		end
	end
end

-- [======= MAIN =======]
while true do
	local neededItems = readNeededItems()
	local missingItems = getMissingItems(neededItems)

	if next(missingItems) ~= nil then
		craftMissingItems(missingItems)
	end

	processCraftingQueue()
	os.sleep(1)
end
