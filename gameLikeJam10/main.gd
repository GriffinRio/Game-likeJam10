extends Node2D
class_name Main

@onready var tile_map: Tile_Map = $TileMap
@onready var player: Player = $Player
@onready var hotbar: Hotbar = $CameraUI/Hotbar
@onready var highlight: Highlight = $WorldUI/Highlight

## Constantly stores mouse position in tile_map terms
var mouse_position
var valid_interactable_distance

# Intializes
func _ready() -> void:
	mouse_position = Tile_Map.map_coord(get_local_mouse_position())
	valid_interactable_distance = within_interactable_range(mouse_position)

# Updates mouse_position
func _process(delta: float) -> void:
	var new_mouse_position = Tile_Map.map_coord(get_local_mouse_position())
	if(mouse_position != new_mouse_position):
		mouse_position = new_mouse_position
		highlight.update_position(mouse_position)
	valid_interactable_distance = within_interactable_range(mouse_position)
	highlight.update_interactable(valid_interactable_distance)

func within_interactable_range(mouse_position: Vector2i):
	var player_tiles = player.tilemap_position()
	var interactable = false
	if(player_tiles.find(mouse_position) == -1):
		for tile in player_tiles:
			if((tile - mouse_position).length() == 1):
				interactable = true
	return interactable

## Connects player destroy to tile_map destroy
func _on_player_destroy_block() -> void:
	if(valid_interactable_distance):
		tile_map.destroy_block(mouse_position)
	else:
		push_warning("Tile not in range of player")
	
## Connects player place to tile_map place
func _on_player_place_block(block: Item) -> void:
	if(valid_interactable_distance):
		tile_map.place_block(mouse_position, block.block)
	else:
		push_warning("Tile not in ranger of player")
	
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
