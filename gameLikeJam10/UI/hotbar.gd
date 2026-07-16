extends Control
class_name Hotbar

@onready var h_box_container: HBoxContainer = $HBoxContainer
var slots : Array[HotbarSlot]
var equipped : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = h_box_container.get_children()
	for child in children:
		slots.append(child)
	equipped = 0
	slots[equipped].equip()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_hotbar(inventory : Array):
	for i in range(len(inventory)):
		slots[i].item = inventory[i]

func update_equipped(new_equipped: int):
	slots[equipped].unequip()
	slots[new_equipped].equip()
	equipped = new_equipped
