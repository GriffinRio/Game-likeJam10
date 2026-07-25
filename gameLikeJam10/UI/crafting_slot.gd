extends Control
class_name CraftingSlot

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var item : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = item.sprite
	label.text = item.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
