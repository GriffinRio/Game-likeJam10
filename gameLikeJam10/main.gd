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
	var block : Block = tile_map.get_tile(tile_position)
	# TODO: System for tools speeding up block breaking depending on type.
	var multiplier : float = 1 / block.break_time
	if(equipped is ItemTools):
		var tool : ItemTools  = equipped
		if(tool.tool_type == block.tool_type):
			multiplier *= tool.multiplier
	breaking.update_position(tile_position)
	breaking.begin_break(multiplier)

func _on_player_stop_mining() -> void:
	breaking.reset_break()

func _on_breaking_finished_break(tile_position: Vector2i) -> void:
	tile_map.destroy_block(tile_position)
