extends Control

const CRAFTING_SLOT = preload("uid://cq0ahleetsyo4")

@onready var grid_container: GridContainer = $GridContainer

@export var recipes : Array[Item]

var crafting_slot_nodes : Array[CraftingSlot] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.crafting.connect(crafting)
	visible = false
	for recipe in recipes:
		var new_slot : CraftingSlot = CRAFTING_SLOT.instantiate()
		new_slot.item = recipe
		grid_container.add_child(new_slot)
		crafting_slot_nodes.append(new_slot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func crafting(currently_crafting : bool, inventory: Array[Item]) -> void:
	visible = currently_crafting
	if(visible):
		for slot in crafting_slot_nodes:
			slot.update_recipe(inventory)
