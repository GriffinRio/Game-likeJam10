extends Control

const CRAFTING_SLOT = preload("uid://cq0ahleetsyo4")

@onready var grid_container: GridContainer = $GridContainer

@export var recipes : Array[Item]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for recipe in recipes:
		var new_slot : CraftingSlot = CRAFTING_SLOT.instantiate()
		new_slot.item = recipe
		grid_container.add_child(new_slot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
