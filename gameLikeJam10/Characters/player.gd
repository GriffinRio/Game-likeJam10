extends CharacterBody2D
class_name Player

## Emmited when player places a valid block
signal place_block(block : Vector2i)
# TODO: Implement item destroying blocks
## Emmited when player starts mining
signal mining(is_mining : bool , item : Item)
## Emmited when player changes equipped item
signal change_equipped(equipped_index : int)

const SPEED = 100.0
const JUMP_VELOCITY = -225.0

var HEIGHT : float
var RADIUS : float

@onready var inventory : Inventory = $Inventory
@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D

var is_mining : bool

func _ready() -> void:
	var hitbox : RectangleShape2D = collision_shape_2d.shape
	HEIGHT = hitbox.size.y / 2.0
	RADIUS = hitbox.size.x / 2.0
	is_mining = false

# Handles player place and destory input for holding functionality
func _process(delta: float) -> void:
	if(Input.is_action_pressed("Place")):
		var to_place : Item = inventory.get_equipped()
		if(to_place != null and to_place.placeable):
			place_block.emit(to_place)
		else:
			push_warning("No block to place")

# Handles player movement
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration and animation.
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		_animated_sprite.play("Player_Walk")
		_animated_sprite.flip_h = (direction < 0)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		_animated_sprite.set_frame_and_progress(4, 0)

	move_and_slide()

# Handles switching hotbar equipped
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("Switch_Item_Up")):
		inventory.change_equipped(-1)
		change_equipped.emit(inventory.equipped)
	elif(event.is_action_pressed("Switch_Item_Down")):
		inventory.change_equipped(1)
		change_equipped.emit(inventory.equipped)
	elif(event.is_action_pressed("Direct_Item_Switch")):
		var keypress : InputEventKey = event
		inventory.change_equipped_direct(keypress.keycode - 49)
		change_equipped.emit(inventory.equipped)
	elif(event.is_action("Destroy")):
		is_mining = !is_mining
		print("mining: " + str(is_mining))
		mining.emit(is_mining, inventory.get_equipped())
		if(is_mining):
			_animated_sprite.play("Player_Mine")
		else:
			_animated_sprite.play("Player_Idle")
		

## Adds given item to player inventory
func pickup_item(item : Item) -> void:
	inventory.gain_item(item)
	
## Removes given item from player inventory
func drop_item(item : Item) -> void:
	inventory.lose_item(item)
	
func tilemap_position() -> Array[Vector2i]:
	var corners : Array[Vector2i] = []
	var collision_position : Vector2 = collision_shape_2d.global_position
	# goes in order from bottem left to top left counter clockwise
	var radius_sign : int = -1
	var height_sign : int = 1
	for i in range(2):
		for j in range(2):
			corners.append(Tile_Map.map_coord(Vector2(collision_position.x + (RADIUS * radius_sign), collision_position.y + (HEIGHT * height_sign))))
			radius_sign *= -1
		height_sign = -1
		radius_sign = 1
	# Gets all the actual tiles in between the corners
	var tiles : Array[Vector2i] = []
	for i in range(4):
		if(corners[i] == corners[(i + 1) % 4]):
			if(tiles.find(corners[i]) == -1):
				tiles.append(corners[i])
		else:
			var line : Array[Vector2i] = Tile_Map.get_tiles_in_line(corners[i], corners[(i + 1) % 4])
			for tile in line:
				if (tiles.find(tile) == -1):
					tiles.append(tile)
	return tiles
