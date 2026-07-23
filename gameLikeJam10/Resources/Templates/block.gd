extends Resource
class_name Block

@export var name : String
@export var tool_type : Enums.tool_type
@export var break_time : float
## Connects to an Item that will be giving to the player when block is broken
@export var drop : Item
