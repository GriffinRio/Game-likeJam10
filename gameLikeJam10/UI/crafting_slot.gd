extends Control
class_name CraftingSlot

const CRAFTING_SLOT_ITEM = preload("uid://daiy6bh2s3g1h")

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var button: Button = $Button

var item : Item
var slot_items : Array[CraftingSlotItem]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = item.sprite
	label.text = item.name.replace("_", " ")
	for need in item.recipe:
		var new_item_display : CraftingSlotItem = CRAFTING_SLOT_ITEM.instantiate()
		new_item_display.goal = need
		v_box_container.add_child(new_item_display)
		slot_items.append(new_item_display)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_recipe(inventory : Array[Item]) -> void:
	var craftable : bool = true
	for i in item.recipe.size():
		var need : Item = item.recipe[i]
		var result : Array[Item] = inventory.filter(func(item_slot : Item) -> bool : return (item_slot != null and item_slot.name == need.name))
		if(result.size() == 1):
			var item_slot : Item = result[0]
			if(item_slot.count < need.count):
				craftable = false
			slot_items[i].update_count(item_slot)
		else:
			craftable = false
	if(not craftable):
		button.disabled = true
	else:
		button.disabled = false
		

func _on_button_pressed() -> void:
	EventBus.emit_signal("give_player_item", item)
