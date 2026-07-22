extends Control
class_name Hotbar

@onready var h_box_container: HBoxContainer = $HBoxContainer

var slots : Array[HotbarSlot]
var equipped : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children : Array[Node] = h_box_container.get_children()
	for child in children:
		slots.append(child)
	equipped = 0
	slots[equipped].equip()
	EventBus.inventory_slot_changed.connect(update_hotbar)
	EventBus.player_equipped_changed.connect(update_equipped)
	
func update_hotbar(index : int, item : Item) -> void:
	slots[index].update(item)

func update_equipped(new_equipped: int) -> void:
	slots[equipped].unequip()
	slots[new_equipped].equip()
	equipped = new_equipped
