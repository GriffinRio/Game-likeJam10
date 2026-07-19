extends Control
class_name Highlight

@onready var panel: Panel = $Panel
@onready var DEBUG_label: Label = $DEBUG_Label
@onready var breaking_animation: AnimatedSprite2D = $BreakingAnimation

var stylebox : StyleBoxFlat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stylebox = panel.get_theme_stylebox("panel","styleboxflat")
	stylebox.border_color = Color.LAWN_GREEN
	DEBUG_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_position(mouse_position : Vector2i) -> void: 
	position = Tile_Map.local_coord(mouse_position)
	DEBUG_label.text = str(mouse_position)

func update_interactable(interactable : bool) -> void:
	if(interactable):
		stylebox.border_color = Color.LAWN_GREEN
	else:
		stylebox.border_color = Color.RED

func breaking() -> void:
	breaking_animation.play()

func reset_break() -> void:
	breaking_animation.stop()
	breaking_animation.frame = 0
