extends TileMapLayer

const EMPTY_TILE = Vector2i(-1,-1)
@onready var highlight: MeshInstance2D = $Highlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = local_to_map(get_local_mouse_position())
	highlight_block(mouse_position)
	if(Input.is_action_pressed("Place")):
		place_block(mouse_position,1)
	elif(Input.is_action_pressed("Destroy")):
		destroy_block(mouse_position)

func place_block(mouse_position, block):
	if(get_cell_atlas_coords(mouse_position) == EMPTY_TILE):
		set_cell(mouse_position, 0, Vector2i(0,0))

func destroy_block(mouse_position):
	var destroy_position = mouse_position
	if(get_cell_atlas_coords(mouse_position) != EMPTY_TILE):
		set_cell(mouse_position, -1, EMPTY_TILE)

func highlight_block(mouse_position):
	highlight.position = map_to_local(mouse_position)
