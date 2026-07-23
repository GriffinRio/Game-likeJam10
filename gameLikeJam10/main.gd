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

func within_interactable_range(mouse_position: Vector2i) -> bool:
	var player_tiles : Array[Vector2i] = player.tilemap_position()
	var interactable : bool = false
	if(player_tiles.find(mouse_position) == -1):
		for tile in player_tiles:
			# print(str(tile) + ": " + str((tile - mouse_position).length()))
			if((tile - mouse_position).length() < 1.5):
				interactable = true
	return interactable

func _on_player_start_mining(tile_position: Vector2i, equipped: Item) -> void:
	var block : Block = tile_map.get_tile(tile_position)
	# TODO: System for tools speeding up block breaking depending on type.
	breaking.update_position(tile_position)
	breaking.begin_break(1.0)

func _on_player_stop_mining() -> void:
	breaking.reset_break()

func _on_breaking_finished_break(tile_position: Vector2i) -> void:
	tile_map.destroy_block(tile_position)
