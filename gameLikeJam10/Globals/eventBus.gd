extends Node

#TODO: MAKE FUNCTIONS TO EMIT EACH OF THESE SIGNALS

signal player_equipped_changed(index: int)

signal inventory_slot_changed(index: int, item: Item)

signal player_place_block(tile_position : Vector2i, block: Vector2i)

signal give_player_item(item : Item)
signal take_player_item(item : Item)
