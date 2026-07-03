extends Node2D

const SPEED = 60

var direction = 1

@onready var rayRight = $RayCastRight
@onready var rayLeft = $RayCastLeft
@onready var sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	if rayRight.is_colliding():
		direction = -1
		sprite.flip_h = true
	if rayLeft.is_colliding():
		direction = 1
		sprite.flip_h = false

	position.x += direction * SPEED * delta
