extends Control
class_name CraftingSlotItem

@onready var texture_rect: TextureRect = $TextureRect
@onready var count: Label = $Count

var goal : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = goal.sprite
	count.text = "0/" + str(goal.count)
	count.label_settings.font_color = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_count(item: Item) -> void:
	count.text = str(item.count) + "/" + str(goal.count)
	#TODO: Changes color of all item descriptions, not just this one :(, use theme overides and not label settings?
	if(item.count < goal.count):
		count.label_settings.font_color = Color.RED
	else:
		count.label_settings.font_color = Color.WHITE
