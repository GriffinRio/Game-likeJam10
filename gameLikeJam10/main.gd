extends Node2D
class_name Main

@onready var tile_map: Tile_Map = $TileMap
@onready var player: Player = $Player
@onready var breaking: Breaking = $WorldUI/Breaking
@onready var end_animation: AnimatedSprite2D = $CameraUI/EndAnimation

## Constantly stores mouse position in tile_map terms

# Intializes
func _ready() -> void:
	end_animation.visible = false

# Updates mouse_position
func _process(delta: float) -> void:
	pass

func _on_player_start_mining(tile_position: Vector2i, equipped: Item) -> void:
	breaking.update_position(tile_position)
	var block : Block = tile_map.get_tile(tile_position)
	if(block != null):
		breaking.begin_break(block, equipped)
	


func _on_end_trigger_body_entered(body: Node2D) -> void:
	end_animation.visible = true
	end_animation.play("End")
	player.process_mode = Node.PROCESS_MODE_DISABLED
