extends Node
class_name Inventory

const size = 10

var hotbar : Array[Item]
var equipped : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equipped = 0
	hotbar = []
	for i in range(size):
		hotbar.append(null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_eqipped(direction : int):
	equipped = ((equipped + direction) % 10 + 10) % 10
	print(str(equipped) + ": " + str(hotbar[equipped]))

func gain_item(item: Item):
	var item_index = hotbar.find(item)
	if(item_index >= 0):
		hotbar[item_index].count += 1
	else:	
		var empty_index = hotbar.find(null)
		if(empty_index >= 0):
			hotbar[empty_index] = item
		else:
			print("No room for item: " + item.name)
	print(hotbar)

func lose_item(item: Item):
	var item_index = hotbar.find(item)
	if(item_index >= 0):
		hotbar[item_index].count -= 1
		if(hotbar[item_index].count < 1):
			hotbar[item_index] = null
	else:
		print("ERROR: Item not in inventory")

func get_equipped():
	return hotbar[equipped]
