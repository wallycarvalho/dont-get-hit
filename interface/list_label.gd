extends Control

@onready var list_item_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list_item_label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	self.custom_minimum_size = Vector2(80, 30)
	#self.size_flags_horizontal = Control.SIZE_EXPAND_FILL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_item_label(value):
	list_item_label.text = value
	
func get_label() -> String:
	return list_item_label.text
	
func set_hor_size_flags(flag) -> void:
	self.size_flags_horizontal = flag
