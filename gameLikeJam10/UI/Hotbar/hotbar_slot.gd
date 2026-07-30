extends Control
class_name HotbarSlot

@onready var item_image: TextureRect = $ItemImage
@onready var stack_count: Label = $StackCount
@onready var panel: Panel = $Panel

var stylebox : StyleBoxFlat
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stylebox = panel.get_theme_stylebox("panel")
	stylebox.border_color = Color.DIM_GRAY


func update(item : Item) -> void:
	if item != null:
		item_image.texture = item.sprite
		if(item.stackable):
			stack_count.text = str(item.count)
			stack_count.visible = true
		else:
			stack_count.text = ""
			stack_count.visible = false
	else:
		item_image.texture = null
		stack_count.text = ""
		stack_count.visible = false
	
func equip() -> void:
	stylebox.border_color = Color.WHITE

func unequip() -> void:
	stylebox.border_color = Color.DIM_GRAY
