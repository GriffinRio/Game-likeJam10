extends Node
class_name Inventory

const SIZE = 10
## Array that stores items that player acquires
var hotbar : Array[Item]
# TODO: move equipped functionality to player?
## Stores index of currently equipped Item
var equipped : int

# Intializes
func _ready() -> void:
	equipped = 0
	hotbar = []
	for i in range(SIZE):
		hotbar.append(null)

# TODO: add support for keyboard inventory switching?
## changes equipped index by 1, positive or negative depending on previous player input
func change_equipped(direction : int):
	# Formula for wrapping array both pos and neg. 
	# Kinda works like if statements, but one math line. 
	equipped = ((equipped + direction) % SIZE + SIZE) % SIZE

## Puts acquired item into inventory. 
## Will stack with other versions of it if item is stackable
## Otherwise, will find new slot for it 
func gain_item(item: Item):
	var item_index = hotbar.find(item)
	if(item.stackable and item_index >= 0):
		hotbar[item_index].count += 1
	else:
		var empty_index = hotbar.find(null)
		# TODO: create new instance of item because it always uses same one from block which is weird?
		if(empty_index >= 0):
			hotbar[empty_index] = item
			if(item.stackable):
				hotbar[empty_index].count = 1
		else:
			push_error("No room for item: " + item.to_string())

# TODO: add functionality for removing multiple counts at once
## Removes item from inventory.
## Either fully removes it with null or just removes a count depending on stackable/count
func lose_item(item: Item):
	var item_index = hotbar.find(item)
	if(item_index >= 0):
		if(not item.stackable || hotbar[item_index].count <= 1):
			hotbar[item_index] = null
		else:
			hotbar[item_index].count -= 1
	else:
		push_error("Item not in inventory")

## Returns currently equipped item
func get_equipped() -> Item:
	return hotbar[equipped]
