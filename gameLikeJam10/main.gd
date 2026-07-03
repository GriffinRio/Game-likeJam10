extends Node2D
class_name Main
var mouse_positiion
@onready var tile_map: Tile_Map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_positiion = tile_map.map_coord(get_local_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_mouse_position = tile_map.map_coord(get_local_mouse_position())
	if(mouse_positiion != new_mouse_position):
		mouse_positiion = new_mouse_position
		tile_map.highlight_block(mouse_positiion)

func _on_player_destroy_block(item: Variant) -> void:
	tile_map.destroy_block(mouse_positiion)

func _on_player_place_block(block: Variant) -> void:
	tile_map.place_block(mouse_positiion, 1)
