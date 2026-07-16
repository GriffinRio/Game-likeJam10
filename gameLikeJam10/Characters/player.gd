extends CharacterBody2D
class_name Player
## Emmited when player places a valid block
signal place_block(block)
# TODO: Implement item destroying blocks
## Emmited when player destroys block
signal destroy_block()
## Emmited when player changes equipped item
signal change_equipped(equipped_index)

const SPEED = 100.0
const JUMP_VELOCITY = -225.0

@onready var inventory: Inventory = $Inventory
@onready var _animated_sprite = $AnimatedSprite2D

# Handles player place and destory input for holding functionality
func _process(delta: float) -> void:
	if(Input.is_action_pressed("Place")):
		var to_place = inventory.get_equipped()
		if(to_place != null and to_place.placeable):
			place_block.emit(to_place)
		else:
			push_warning("No block to place")
	# TODO: Implement item destroying blocks
	elif(Input.is_action_pressed("Destroy")):
		#TODO: Fix animation being a still image, make animation directional
		_animated_sprite.play("Player_Mine")
		destroy_block.emit()
	elif(Input.is_action_just_released("Destroy")):
		_animated_sprite.play("Player_Idle")

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
		inventory.change_equipped(1)
		change_equipped.emit(inventory.equipped)
	elif(event.is_action_pressed("Switch_Item_Down")):
		inventory.change_equipped(-1)
		change_equipped.emit(inventory.equipped)

## Adds given item to player inventory
func pickup_item(item : Item):
	inventory.gain_item(item)
	
## Removes given item from player inventory
func drop_item(item : Item):
	inventory.lose_item(item)
