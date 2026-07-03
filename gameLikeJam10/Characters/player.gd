extends CharacterBody2D
class_name Player
const SPEED = 100.0
const JUMP_VELOCITY = -200.0
signal place_block(block)
signal destroy_block(item)

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
