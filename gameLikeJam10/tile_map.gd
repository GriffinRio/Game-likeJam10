extends Node2D
class_name Tile_Map

signal block_destroyed(block : Block)
signal block_placed(block : Block)

const EMPTY_TILE = Vector2i(-1,-1)
const TILE_SIZE = 24

@onready var highlight: MeshInstance2D = $Highlight
@onready var tile_layer: TileMapLayer = $TileLayer

static func map_coord(position : Vector2) -> Vector2i:
	return Vector2i(floor(position/TILE_SIZE))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight_block(mouse_position):
	highlight.position = tile_layer.map_to_local(mouse_position)

func place_block(mouse_position, block : Vector2i):
	if(tile_layer.get_cell_atlas_coords(mouse_position) == EMPTY_TILE):
		tile_layer.set_cell(mouse_position, 1, block)
		var placed : Block = tile_layer.get_cell_tile_data(mouse_position).get_custom_data("block_data")
		block_placed.emit(placed)

func destroy_block(mouse_position):
	if(tile_layer.get_cell_atlas_coords(mouse_position) != EMPTY_TILE):
		# figure out how to link mining animation to block destruction, global variable back to player?
		var block: Block = tile_layer.get_cell_tile_data(mouse_position).get_custom_data("block_data")
		tile_layer.set_cell(mouse_position, -1, EMPTY_TILE)
		block_destroyed.emit(block)
