extends CharacterBody2D

@onready var model_anim = get_node("SubViewport/PlayerModel/lava_boy_skeleton/AnimationPlayer")
const SPEED = 300.0
const JUMP_VELOCITY = -575.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	$SprPlayer.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$SprPlayer.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		model_anim.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if velocity.x < 0:
			$SprPlayer.flip_h = true
		else:
			$SprPlayer.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor() and not model_anim.is_playing() and not model_anim.current_animation == "jump":
		if direction:
			model_anim.play("renderwire")
		else:
			model_anim.play("renderwire")
			model_anim.stop()
	elif is_on_floor() and model_anim.is_playing() and model_anim.current_animation == "Skeleton_001Action" and not direction:
		model_anim.play("renderwire")
		model_anim.stop()
	elif is_on_floor() and model_anim.is_playing() and model_anim.current_animation == "renderwire" and not direction:
		model_anim.play("renderwire")
		model_anim.stop()
	elif not is_on_floor() and velocity.y > 0 and not model_anim.current_animation == "jump" and not model_anim.current_animation == "Skeleton_001Action":
		model_anim.play("Skeleton_001Action")
		
	
	move_and_slide()
