---@meta

---@class AE2Controller
---@field findItem fun(item:string|table):AE2ItemDetails -- Search for an item in the network. You can specify the item as a string, with ot without the damage value ('minecraft:stone' or 'minecraft:stone@0'), or as a table with 'name', 'damage' and 'nbthash' fields. You must specify the 'name', but you can leave the other fields empty.
---@field findItems fun(item:string|table):AE2ItemDetails[] -- Search for all items in the network. You can specify the item as a string, with ot without the damage value ('minecraft:stone' or 'minecraft:stone@0'), or as a table with 'name', 'damage' and 'nbthash' fields. You must specify the 'name', but you can leave the other fields empty.
---@field getCraftingCPUs fun():table -- Get a list of all crafting CPUs in the network.
---@field getDemandedEnergy fun():number -- The maximum amount of EU that can be received.
---@field getDocs fun([name: string]):string|table -- Get the documentation for all functions or the function specified. Errors if the function cannot be found.
---@field getMetadata fun():table -- Get metadata about this object/
---@field getNetworkEnergyStored fun():number -- Get the amount of energy stored in this AE network.
---@field getEnergyUsage fun():number -- Get the amount of energy used by this AE network.
---@field getNodeEnergyUsage fun():number -- Get the amount of energy used by this AE node.
---@field getSinkTier fun():number -- Get the tier of this EU sink. 1 = LV, 2 = MV, 3 = HV, 4 = EV etc.
---@field listAvailableItems fun():AE2Item[] -- List all items which are stored (or craftable) in this network.

---@class AE2Item
---@field count number -- The number of items in the network.
---@field damage number -- The damage value of the item.
---@field isCraftable boolean -- Whether the item is craftable.
---@field name string -- The name of the item.

---@class AE2ItemDetails
---@field craft fun(quantity:number):AE2CraftingTask -- Craft this item, returning a reference to the crafting task.
---@field export fun(toName:string[, limit:number[, toSlot:number]]):number -- Export this item from the AE network to an inventory. Returns the amount transferred.
---@field getDocs fun([name: string]):string|table -- Get the documentation for all functions or the function specified. Errors if the function cannot be found.
---@field getMetadata fun():table -- Get metadata about this object.
---@field getTransferLocations fun([location:string]):table -- Get a list of all available objects which can be transferred to or from.

---@class AE2CraftingTask
---@field getComponents fun():table -- Get a the various items required for this crafting task.
---@field getDocs fun([name: string]):string|table -- Get the documentation for all functions or the function specified. Errors if the function cannot be found.
---@field getId fun():number -- Get the ID of this crafting task.
---@field isCanceled fun():boolean -- Whether this crafting task has been canceled.
---@field isFinished fun():boolean -- Whether this crafting task has been finished.
---@field status fun():string -- Get the status of this crafting task.
