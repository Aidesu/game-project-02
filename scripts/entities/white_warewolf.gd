extends Node2D

const SPEED = 60

var damage = 10
var direction = 1

@onready var rayRight = $RayCastRight
@onready var rayLeft = $RayCastLeft
@onready var sprite = $AnimatedSprite2D
@onready var attackZone1= $"AttackZone-1"

func _process(delta: float) -> void:
	if rayRight.is_colliding():
		direction = -1
		sprite.flip_h = true
	if rayLeft.is_colliding():
		direction = 1
		sprite.flip_h = false

	position.x += direction * SPEED * delta


func _on_attack_zone_1_body_entered(body: Node2D) -> void:
	sprite.play("attack-1")
	if body.has_method("damage"):
		body.damage(damage)

func _on_attack_zone_1_body_exited(body: Node2D) -> void:
	sprite.play("idle")
