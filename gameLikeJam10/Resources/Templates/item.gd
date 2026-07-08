extends Resource
class_name Item

@export var name : String
@export var sprite : Texture2D

@export_group("Stacks")
@export var stackable: bool
@export var count : int

@export_group("Blocks")
@export var placeable: bool
@export var block : Vector2i

func _to_string() -> String:
	var output = ""
	output += name + "\n"
	output += "Stackable: " + str(stackable) + "\n"
	if(stackable):
		output += "Count: " + str(count) + "\n"
	output += "Placeable: " + str(placeable) + "\n"
	return output
