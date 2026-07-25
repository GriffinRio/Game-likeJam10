extends Node2D
class_name Main

@onready var tile_map: Tile_Map = $TileMap
@onready var player: Player = $Player
@onready var breaking: Breaking = $WorldUI/Breaking
## Constantly stores mouse position in tile_map terms

# Intializes
func _ready() -> void:
	pass

# Updates mouse_position
func _process(delta: float) -> void:
	pass

# TODO: Could change to just be global signals emmited between all these nodes, probably cleaner

func _on_player_start_mining(tile_position: Vector2i, equipped: Item) -> void:
	breaking.update_position(tile_position)
	var block : Block = tile_map.get_tile(tile_position)
	breaking.begin_break(block, equipped)
	
