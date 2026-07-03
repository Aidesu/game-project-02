extends Node2D

enum State { IDLE, WALK, RUN }

@export var walk_speed = 60.0
@export var run_speed = 140.0
@export var chase_radius = 150.0 # en dessous de cette distance -> il court

var damage = 10
var state = State.IDLE
var target: Node2D = null
var is_attacking = false
var vision_radius = 300.0 # lu depuis la forme de TargetingZone

@onready var sprite = $AnimatedSprite2D
@onready var targeting_zone = $TargetingZone
@onready var attack_zone = $"AttackZone-1"


func _ready() -> void:
	sprite.play("idle")
	var targeting_shape = $TargetingZone/CollisionShape2D.shape
	if targeting_shape is CircleShape2D:
		vision_radius = targeting_shape.radius


func _process(delta: float) -> void:
	if is_attacking:
		return

	if target == null:
		state = State.IDLE
		sprite.play("idle")
		return

	var distance = abs(target.global_position.x - global_position.x)

	if distance > vision_radius:
		target = null
		state = State.IDLE
		sprite.play("idle")
		return

	var dir_to_target = signf(target.global_position.x - global_position.x)
	if dir_to_target != 0:
		sprite.flip_h = dir_to_target < 0

	if distance <= chase_radius:
		state = State.RUN
		sprite.play("run")
		global_position.x += dir_to_target * run_speed * delta
	else:
		state = State.WALK
		sprite.play("walk")
		global_position.x += dir_to_target * walk_speed * delta


func _play_current_state_animation() -> void:
	match state:
		State.RUN:
			sprite.play("run")
		State.WALK:
			sprite.play("walk")
		_:
			sprite.play("idle")


func _on_targeting_zone_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		target = body


func _on_targeting_zone_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _on_attack_zone_1_body_entered(body: Node2D) -> void:
	if not body.has_method("damage"):
		return
	is_attacking = true
	sprite.play("attack-1")
	body.damage(damage)


func _on_attack_zone_1_body_exited(body: Node2D) -> void:
	is_attacking = false
	_play_current_state_animation()
