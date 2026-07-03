extends CharacterBody2D
class_name Player

signal place_block(block)
signal destroy_block(item)

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var inventory = [1,2,3,4,5,6,7,8,9,10]
var equipped = 0

func _process(delta: float) -> void:
	if(Input.is_action_pressed("Place")):
		place_block.emit(1)
	elif(Input.is_action_pressed("Destroy")):
		destroy_block.emit(1)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("Switch_Item_Up")):
		equipped = (equipped + 1) % 10
		print(inventory[equipped])
	elif(event.is_action_pressed("Switch_Item_Down")):
		equipped = (equipped - 1) % 10
		print(inventory[equipped])
