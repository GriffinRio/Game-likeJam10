extends Node

#TODO: MAKE FUNCTIONS TO EMIT EACH OF THESE SIGNALS

signal player_equipped_changed(index: int)

signal inventory_slot_changed(index: int, item: Item)

signal player_place_block(tile_position : Vector2i, block: Vector2i)

signal player_stop_mining()
signal breaking_animation_finished(tile_position : Vector2i, give_drop : bool)

signal give_player_item(item : Item, count : int)
signal take_player_item(item : Item, count : int)

signal crafting(currently_crafting : bool, new_inventory : Array[Item])
