extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var count = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction = Input.get_axis("move_left", "move_right")
	var action = Input.get_axis("squat", "attack")
	# Flip the sprite
	if direction > 0 :
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Player animation
	if is_on_floor():
		if action == -1:
			animated_sprite_2d.play("squat")
		elif action == 1:
			animated_sprite_2d.play("attack")
		elif direction == 0:
			if count == 0:
				animated_sprite_2d.play("sleep")
			else:
				count -= 1
				animated_sprite_2d.play("idle")
		else:
			count = 300
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	# Apply Move
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
