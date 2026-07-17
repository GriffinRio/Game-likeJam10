extends Node2D
class_name Tile_Map
## Emmited when destroy_block is sucessful
signal block_destroyed(block : Block)
## Emmitted when place_block is sucessful 
signal block_placed(block : Block)

const EMPTY_TILE = Vector2i(-1,-1)
const TILE_SIZE = 24

@onready var tile_layer: TileMapLayer = $TileLayer
## Allows all nodes/scripts to convert coordinates to tile_map coords
static func map_coord(position : Vector2) -> Vector2i:
	return Vector2i(floor(position/TILE_SIZE))

static func local_coord(position : Vector2i) -> Vector2:
	return Vector2i(position * TILE_SIZE)

## Makes sure block can be placed and then does so. Emits block_placed to remove block from player inventory
func place_block(mouse_position, block : Vector2i):
	if(tile_layer.get_cell_atlas_coords(mouse_position) == EMPTY_TILE):
		tile_layer.set_cell(mouse_position, 1, block)
		var placed : Block = tile_layer.get_cell_tile_data(mouse_position).get_custom_data("block_data")
		block_placed.emit(placed)

## Makes sure block can be destroyed and then does so. Emits block_destroyed to add block to player inventory
func destroy_block(mouse_position):
	if(tile_layer.get_cell_atlas_coords(mouse_position) != EMPTY_TILE):
		#TODO: figure out how to link mining animation to block destruction, global variable back to player?
		var block: Block = tile_layer.get_cell_tile_data(mouse_position).get_custom_data("block_data")
		tile_layer.set_cell(mouse_position, -1, EMPTY_TILE)
		block_destroyed.emit(block)
