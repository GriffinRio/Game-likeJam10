extends Node

signal player_equipped_changed(index: int)

signal inventory_slot_changed(index: int, item: Item)

signal player_place_block()

signal give_player_item(item : Item)
signal take_player_item(item : Item)
