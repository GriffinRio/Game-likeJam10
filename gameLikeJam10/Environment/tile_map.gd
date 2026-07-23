extends Node2D
class_name Tile_Map

const EMPTY_TILE = Vector2i(-1,-1)
const TILE_SIZE = 24

@onready var tile_layer: TileMapLayer = $TileLayer

## Allows all nodes/scripts to convert coordinates to tile_map coords
static func map_coord(position : Vector2) -> Vector2i:
	var calculation : Vector2i = floor(position/TILE_SIZE)
	return calculation

static func local_coord(position : Vector2i) -> Vector2:
	var calculation : Vector2i = position * TILE_SIZE
	return calculation
	
static func get_tiles_in_line(tile_start : Vector2i, tile_end : Vector2i) -> Array[Vector2i]:
	var tiles : Array[Vector2i] = [tile_start]
	var diff : Vector2i = tile_end - tile_start
	var axis : int
	if(diff.x == 0):
		axis = 1
	else:
		axis = 0
	var length : int = abs(diff[axis])
	var direction : int = diff[axis] / length
	for i in range(length):
		var tile : Vector2i = tiles[-1]
		tile[axis] = tile[axis] + (1 * direction)
		tiles.append(tile)
	return tiles

func _ready() -> void:
	pass

func get_tile(tile_position : Vector2i) -> Block :
	var block: Block = tile_layer.get_cell_tile_data(tile_position).get_custom_data("block_data")
	return block

## Makes sure block can be placed and then does so. Emits block_placed to remove block from player inventory
func place_block(tile_position : Vector2i, block : Vector2i) -> void:
	if(tile_layer.get_cell_atlas_coords(tile_position) == EMPTY_TILE):
		tile_layer.set_cell(tile_position, 1, block)
		var placed : Block = tile_layer.get_cell_tile_data(tile_position).get_custom_data("block_data")

## Makes sure block can be destroyed and then does so. Emits block_destroyed to add block to player inventory
func destroy_block(tile_position : Vector2i) -> void:
	if(tile_layer.get_cell_atlas_coords(tile_position) != EMPTY_TILE):
		var block: Block = tile_layer.get_cell_tile_data(tile_position).get_custom_data("block_data")
		tile_layer.set_cell(tile_position, -1, EMPTY_TILE)
		EventBus.give_player_item.emit(block.drop)
	else:
		push_error("Tile doesn't exist")
