extends Node2D
class_name Tile_Map
@onready var highlight: MeshInstance2D = $Highlight
@onready var tile_layer: TileMapLayer = $TileLayer

const EMPTY_TILE = Vector2i(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func map_coord(mouse_position):
	return tile_layer.local_to_map(mouse_position)

func highlight_block(mouse_position):
	highlight.position = tile_layer.map_to_local(mouse_position)

func place_block(mouse_position, block):
	if(tile_layer.get_cell_atlas_coords(mouse_position) == EMPTY_TILE):
		tile_layer.set_cell(mouse_position, 0, Vector2i(0,0))

func destroy_block(mouse_position):
	if(tile_layer.get_cell_atlas_coords(mouse_position) != EMPTY_TILE):
		tile_layer.set_cell(mouse_position, -1, EMPTY_TILE)
