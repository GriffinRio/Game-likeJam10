extends Control
class_name Highlight

@onready var panel: Panel = $Panel
@onready var DEBUG_label: Label = $DEBUG_Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.get_theme_stylebox("panel").border_color = Color.LAWN_GREEN
	DEBUG_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_position(mouse_position : Vector2i): 
	position = Tile_Map.local_coord(mouse_position)
	DEBUG_label.text = str(mouse_position)

func update_interactable(interactable):
	if(interactable):
		panel.get_theme_stylebox("panel").border_color = Color.LAWN_GREEN
	else:
		panel.get_theme_stylebox("panel").border_color = Color.RED
