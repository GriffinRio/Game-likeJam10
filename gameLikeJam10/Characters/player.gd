extends CharacterBody2D
class_name Player

signal place_block(block)
signal destroy_block()

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

@onready var inventory: Inventory = $Inventory

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(Input.is_action_pressed("Place")):
		var to_place = inventory.get_equipped()
		if(to_place != null and to_place.placeable):
			place_block.emit(to_place)
		else:
			print("No block to place")
	elif(Input.is_action_pressed("Destroy")):
		destroy_block.emit()

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
		inventory.change_eqipped(1)
	elif(event.is_action_pressed("Switch_Item_Down")):
		# ((equipped - 1) % 10 + 10) makes the index positive, the extra % 10 wraps if needed
		inventory.change_eqipped(-1)

func pickup_item(item : Item):
	inventory.gain_item(item)

func drop_item(item : Item):
	inventory.lose_item(item)
