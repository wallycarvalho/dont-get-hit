extends Panel

@export var bounce_height: float = 10.0
@export var bounce_duration: float = 0.5
@export var bounce_interval: float = 1.5

var base_position: Vector2
var time_since_last_bounce: float = 0.0
var is_bouncing: bool = false
var bounce_progress: float = 0.0

func _ready() -> void:
	base_position = position

func _process(delta: float) -> void:
	time_since_last_bounce += delta
	
	# Start bounce animation every bounce_interval seconds
	if time_since_last_bounce >= bounce_interval and not is_bouncing:
		start_bounce()
	
	# Update bounce animation
	if is_bouncing:
		bounce_progress += delta / bounce_duration
		if bounce_progress >= 1.0:
			is_bouncing = false
			bounce_progress = 0.0
			position = base_position
			time_since_last_bounce = 0.0
		else:
			# Ease out animation for bounce effect
			var eased_progress = sin(bounce_progress * PI)
			position.y = base_position.y - (bounce_height * eased_progress)

func start_bounce() -> void:
	is_bouncing = true
	bounce_progress = 0.0
