extends Node2D
class_name SpaceShip

@onready var interact_text: Control = $Interact_Text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact_text.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	interact_text.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	interact_text.visible = false
