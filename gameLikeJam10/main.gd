extends Node2D
class_name Main

@onready var tile_map: Tile_Map = $TileMap
@onready var player: Player = $Player
@onready var hotbar: Hotbar = $CameraUI/Hotbar
@onready var highlight: Highlight = $WorldUI/Highlight

## Constantly stores mouse position in tile_map terms
var mouse_position : Vector2i
var valid_interactable_distance : bool

# Intializes
func _ready() -> void:
	mouse_position = Tile_Map.map_coord(get_local_mouse_position())
	valid_interactable_distance = within_interactable_range(mouse_position)

# Updates mouse_position
func _process(delta: float) -> void:
	var new_mouse_position : Vector2i = Tile_Map.map_coord(get_local_mouse_position())
	if(mouse_position != new_mouse_position):
		mouse_position = new_mouse_position
		highlight.update_position(mouse_position)
		highlight.reset_break()
		_on_player_mining(player.is_mining, player.inventory.get_equipped())
	valid_interactable_distance = within_interactable_range(mouse_position)
	highlight.update_interactable(valid_interactable_distance)

func within_interactable_range(mouse_position: Vector2i) -> bool:
	var player_tiles : Array[Vector2i] = player.tilemap_position()
	var interactable : bool = false
	if(player_tiles.find(mouse_position) == -1):
		for tile in player_tiles:
			if((tile - mouse_position).length() == 1):
				interactable = true
	return interactable
	
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


func _on_player_change_equipped(equipped_index: int) -> void:
	hotbar.update_equipped(equipped_index)


func _on_player_mining(is_mining: bool, item: Item) -> void:
	if(valid_interactable_distance and is_mining):
		highlight.breaking()
		await  highlight.breaking_animation.animation_finished
		tile_map.destroy_block(mouse_position)
		highlight.reset_break()
	else:
		highlight.reset_break()
		push_warning("Tile not in range of player")
