extends CharacterBody2D


var speed = 200.0

const JUMP_VELOCITY = -400.0
var jumpCount = 2
var life = 100


@onready var sprite = $AnimatedSprite2D
@onready var hud = %HUD

func _ready() -> void:
	hud.refreshLife.call_deferred(str(life))

func damage(nmb):
	life -= nmb
	if life >= 1:
		hud.refreshLife(str(life))
	elif life <= 0:
		print("Death")
		sprite.play("death")
		hud.refreshLife("0")
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		jumpCount = 2

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumpCount > 0:
		velocity.y = JUMP_VELOCITY
		jumpCount -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			if Input.is_action_pressed("sprint"):
				speed = 400
				sprite.play("run")
			else:
				speed = 200
				sprite.play("walk")
	else:
		sprite.play("jump")
		
	
	if direction:
		velocity.x = direction * speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
