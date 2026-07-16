extends Node2D
class_name Main
## Constantly stores mouse position in tile_map terms
var mouse_positiion
@onready var tile_map: Tile_Map = $TileMap
@onready var player: Player = $Player
@onready var hotbar: Hotbar = $CanvasLayer/Hotbar


# Intializes
func _ready() -> void:
	mouse_positiion = Tile_Map.map_coord(get_local_mouse_position())

# Updates mouse_position
func _process(delta: float) -> void:
	var new_mouse_position = Tile_Map.map_coord(get_local_mouse_position())
	if(mouse_positiion != new_mouse_position):
		mouse_positiion = new_mouse_position
		tile_map.highlight_block(mouse_positiion)

# TODO: Maybe directly connect player to tilemap? up/down good practice?
## Connects player destroy to tile_map destroy
func _on_player_destroy_block() -> void:
	tile_map.destroy_block(mouse_positiion)
	
## Connects player place to tile_map place
func _on_player_place_block(block: Item) -> void:
	tile_map.place_block(mouse_positiion, block.block)
	
## Connects player inventory to tile_map destroy
func _on_tile_map_block_destroyed(block: Block) -> void:
	player.pickup_item(block.drop)
	hotbar.update_hotbar(player.inventory.get_inventory())

## Connects player inventory to tile_map place
func _on_tile_map_block_placed(block: Block) -> void:
	player.drop_item(block.drop)
	hotbar.update_hotbar(player.inventory.get_inventory())


func _on_player_change_equipped(equipped_index: Variant) -> void:
	hotbar.update_equipped(equipped_index)
