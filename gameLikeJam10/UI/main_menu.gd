extends Control

const MAIN = preload("uid://8mqlsnp7uqw4")
@onready var controls: Control = $Controls


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controls.visible = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)


func _on_controls_pressed() -> void:
	controls.visible = true

func _on_exit_controls_pressed() -> void:
	controls.visible = false
