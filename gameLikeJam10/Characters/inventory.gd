extends Node
class_name Inventory

const SIZE = 10
## Array that stores items that player acquires
var hotbar : Array[Item]

# Intializes
func _ready() -> void:
	hotbar = []
	for i in range(SIZE):
		hotbar.append(null)

## Puts acquired item into inventory. 
## Will stack with other versions of it if item is stackable
## Otherwise, will find new slot for it 
func gain_item(item: Item) -> void:
	var item_index : int = hotbar.find(item)
	if(item.stackable and item_index >= 0):
		hotbar[item_index].count += 1
		EventBus.inventory_slot_changed.emit(item_index, hotbar[item_index])
	else:
		var empty_index : int = hotbar.find(null)
		# TODO: create new instance of item because it always uses same one from block which is weird?
		if(empty_index >= 0):
			hotbar[empty_index] = item
			if(item.stackable):
				hotbar[empty_index].count = 1
			EventBus.inventory_slot_changed.emit(empty_index, hotbar[empty_index])
		else:
			push_warning("No room for item: " + item.to_string())

# TODO: add functionality for removing multiple counts at once
## Removes item from inventory.
## Either fully removes it with null or just removes a count depending on stackable/count
func lose_item(item: Item)  -> void:
	var item_index : int = hotbar.find(item)
	if(item_index >= 0):
		if(not item.stackable || hotbar[item_index].count <= 1):
			hotbar[item_index] = null
		else:
			hotbar[item_index].count -= 1
		EventBus.inventory_slot_changed.emit(item_index, hotbar[item_index])
	else:
		push_error("Item not in inventory")

## Returns currently equipped item
func get_item(index : int) -> Item:
	return hotbar[index]
