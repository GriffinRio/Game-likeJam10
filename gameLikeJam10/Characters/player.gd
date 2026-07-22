extends CharacterBody2D
class_name Player

## Emmited when player places a valid block
signal place_block(block : Vector2i)
# TODO: Implement item destroying blocks
## Emmited when player starts mining
signal mining(is_mining : bool , item : Item)

const SPEED = 100.0
const JUMP_VELOCITY = -225.0

var RADIUS_Y : float
var RADIUS_X : float

@onready var inventory : Inventory = $Inventory
@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D
@onready var animation_tree : AnimationTree = $AnimationTree
var is_mining : bool
var equipped : int

func _ready() -> void:
	animation_tree.active = true
	var hitbox : RectangleShape2D = collision_shape_2d.shape
	RADIUS_Y = hitbox.size.y / 2.0
	RADIUS_X = hitbox.size.x / 2.0
	is_mining = false
	equipped = 0

# Handles player place and destory input for holding functionality
func _process(delta: float) -> void:
	if(Input.is_action_pressed("Place")):
		var to_place : Item = get_equipped()
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
	animation_tree.set("parameters/Move/blend_position", direction)
	animation_tree.set("parameters/conditions/is_mining", is_mining)
	animation_tree.set("parameters/conditions/!is_mining", !is_mining)
	
	if direction:
		_animated_sprite.flip_h = (direction < 0)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Handles switching hotbar equipped
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("Switch_Item_Up")):
		var new_index : int = ((equipped - 1) + inventory.SIZE) % inventory.SIZE
		change_equipped(new_index)
		#change_equipped.emit(inventory.equipped)
	elif(event.is_action_pressed("Switch_Item_Down")):
		var new_index : int = (equipped + 1) % inventory.SIZE
		change_equipped(new_index)
		#change_equipped.emit(inventory.equipped)
	elif(event.is_action_pressed("Direct_Item_Switch")):
		var keypress : InputEventKey = event
		change_equipped(keypress.keycode - 49)
		#change_equipped.emit(inventory.equipped)
	elif(event.is_action("Destroy")):
		is_mining = !is_mining
		print("mining: " + str(is_mining))
		mining.emit(is_mining, get_equipped())

## changes equipped
func change_equipped(index : int) -> void:
	equipped = (index + inventory.SIZE) % inventory.SIZE
	EventBus.player_equipped_changed.emit(equipped)

func get_equipped() -> Item:
	return inventory.get_item(equipped)

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
			corners.append(Tile_Map.map_coord(Vector2(collision_position.x + (RADIUS_X * radius_sign), collision_position.y + (RADIUS_Y * height_sign))))
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
