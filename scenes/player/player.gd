extends CharacterBody2D

@onready var model_anim = get_node("SubViewport/PlayerModel/lava_boy_skeleton/AnimationPlayer")
const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	$SprPlayer.texture = $SubViewport.get_texture()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if model_anim.current_animation != "renderwire":
			model_anim.play("renderwire")
		if velocity.x < 0:
			$SprPlayer.flip_h = true
		else:
			$SprPlayer.flip_h = false
		velocity.x = direction * SPEED
	else:
		model_anim.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
