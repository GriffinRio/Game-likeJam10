@tool #Allows script to interact with editor
extends Resource
class_name Item

@export var name : String
## Image shown in inventory and crafting UI
@export var sprite : Texture2D

@export_group("Stacks")
## Defines if a item is stackable or not. If so, store a count
@export var stackable: bool :
	# Connects to _validate_property()
	set(value):
		stackable = value
		notify_property_list_changed()
@export var count : int

# TODO: Don't love how the block property is setup
@export_group("Blocks")
## Defines if a item is placeable or not. If so, store a reference to the tilemap
@export var placeable: bool :
	# Connects to _validate_property()
	set(value):
		placeable = value
		notify_property_list_changed()
## Location in tilemap atlas for the block to be placed
@export var block : Vector2i

# Only shows count if stackable and block if placeable. 
func _validate_property(property: Dictionary) -> void:
	if(property.name == "count" and not stackable):
		#property.usage |= PROPERTY_USAGE_READ_ONLY
		property.usage = PROPERTY_USAGE_NONE
	if(property.name == "block" and not placeable):
		#property.usage |= PROPERTY_USAGE_READ_ONLY
		property.usage = PROPERTY_USAGE_NONE
	
func _to_string() -> String:
	var output : String = ""
	output += name + "\n"
	output += "Stackable: " + str(stackable) + "\n"
	if(stackable):
		output += "Count: " + str(count) + "\n"
	output += "Placeable: " + str(placeable) + "\n"
	return output
	
