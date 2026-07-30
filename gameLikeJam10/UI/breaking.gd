extends Control
class_name Breaking

const DEFAULT_SPEED : float = 1.0
@onready var breaking_animation: AnimatedSprite2D = $BreakingAnimation

var give_drop : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_break()
	EventBus.player_stop_mining.connect(reset_break)
	give_drop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_position(mouse_position : Vector2i) -> void: 
	position = Tile_Map.local_coord(mouse_position)

func begin_break(block : Block, equipped : Item) -> void:
	var break_time : float = block.hardness
	if(equipped is ItemTools):
		var tool : ItemTools = equipped
		if(block.drop_tools.size() == 0 or tool in block.drop_tools):
			give_drop = true
			break_time *= 1.5
		else:
			give_drop = false
			break_time *= 5.0
		if(tool.tool_type == block.tool_type):
			break_time /= tool.multiplier
	else:
		if(block.drop_tools.size() == 0):
			give_drop = true
			break_time *= 1.5
		else:
			give_drop = false
			break_time *= 5.0
	breaking_animation.play("Breaking", 1/break_time)

func reset_break() -> void:
	breaking_animation.speed_scale = DEFAULT_SPEED
	breaking_animation.stop()
	breaking_animation.frame = 0

func _on_breaking_animation_animation_finished() -> void:
	reset_break()
	EventBus.breaking_animation_finished.emit(Tile_Map.map_coord(position), give_drop)
