extends Control
class_name Breaking

signal finished_break(tile_position: Vector2i)

const DEFAULT_SPEED : float = 1.0
@onready var DEBUG_label: Label = $DEBUG_Label
@onready var breaking_animation: AnimatedSprite2D = $BreakingAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DEBUG_label.text = ""
	reset_break()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_position(mouse_position : Vector2i) -> void: 
	position = Tile_Map.local_coord(mouse_position)
	DEBUG_label.text = str(mouse_position)

func begin_break(speed : float) -> void:
	breaking_animation.play("Breaking", speed)

func reset_break() -> void:
	breaking_animation.speed_scale = DEFAULT_SPEED
	breaking_animation.stop()
	breaking_animation.frame = 0

func _on_breaking_animation_animation_finished() -> void:
	reset_break()
	finished_break.emit(Tile_Map.map_coord(position))
