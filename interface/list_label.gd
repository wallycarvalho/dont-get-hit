extends Control

@onready var list_item_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list_item_label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_item_label(value):
	list_item_label.text = value
