extends CharacterBody2D

const death_screen = preload("res://assets/menu/death_screen/death_screen.tscn")

@onready var model_anim = get_node("SubViewport/lava_boy_skeleton/AnimationPlayer")
const SPEED = 300.0
const JUMP_VELOCITY = -575.0
var coyote_time = 100

var direction: float = 1
var acceleration: float = 600
var deceleration: float = 3
var speed_cap: float = 300

var last_on_floor: int = 0

var wisps: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	$SprPlayer.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$SprPlayer.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)
	
	# Lava death
	if global_position.y > 300:
		die()

func _physics_process(delta):
	move_player(delta)
	
	if direction == -1:
		$SprPlayer.flip_h = true
	else:
		$SprPlayer.flip_h = false
	var direction = Input.get_axis("left", "right")
	if is_on_floor() and not model_anim.current_animation == "jump":
		if model_anim.current_animation != "renderwire" and direction:
			model_anim.play("renderwire")
		elif not direction and not model_anim.current_animation == "renderwire_001":
			model_anim.play("renderwire_001")
	elif is_on_floor() and model_anim.current_animation == "Skeleton_001Action":
		if direction:
			model_anim.play("renderwire")
		elif not model_anim.current_animation == "renderwire_001":
			model_anim.play("renderwire_001")
	elif is_on_floor() and model_anim.current_animation == "renderwire" and not model_anim.current_animation == "renderwire_001" and not direction:
		model_anim.play("renderwire_001")
	elif not is_on_floor() and velocity.y > 0 and not model_anim.current_animation == "jump" and not model_anim.current_animation == "Skeleton_001Action":
		model_anim.play("Skeleton_001Action")
	
	
	move_and_slide()
	
	


func move_player(delta):
	# Drop through platforms
	if Input.is_action_pressed("down"):
		set_collision_mask_value(1, false)
	else:
		set_collision_mask_value(1, true)
	
	# Set direction
	if Input.is_action_just_pressed("left") or (Input.is_action_pressed("left") and not Input.is_action_pressed("right")):
		direction = -1
	if Input.is_action_just_pressed("right") or (Input.is_action_pressed("right") and not Input.is_action_pressed("left")):
		direction = 1
	
	# Move left/right
	if Input.is_action_pressed("left") and direction == -1:
		velocity.x -= acceleration * delta
	if Input.is_action_pressed("right") and direction == 1:
		velocity.x += acceleration * delta
	
	# Cap horizontal speed
	if velocity.x > speed_cap:
		velocity.x = speed_cap
	if velocity.x < -speed_cap:
		velocity.x = -speed_cap
	
	# Decelerate toward 0 when not holding left
	if not Input.is_action_pressed("left") or direction == 1:
		if velocity.x > -acceleration * deceleration * delta and velocity.x < 0:
			velocity.x = 0
		if velocity.x <= -acceleration * deceleration * delta:
			velocity.x += acceleration * deceleration * delta
	
	# Decelerate toward 0 when not holding right
	if not Input.is_action_pressed("right") or direction == -1:
		if velocity.x < acceleration * deceleration * delta and velocity.x > 0:
			velocity.x = 0
		if velocity.x >= acceleration * deceleration * delta:
			velocity.x -= acceleration * deceleration * delta
	
	# Coyote time
	if is_on_floor():
		last_on_floor = Time.get_ticks_msec()
	
	# Jump
	if Input.is_action_just_pressed("jump") and Time.get_ticks_msec() - last_on_floor <= coyote_time:
		velocity.y = JUMP_VELOCITY
		model_anim.play("jump")
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

func die():
	var time = get_tree().root.get_node("Game/LavaMap").time_score_thing
	get_tree().root.get_node("Game/LavaMap").queue_free()
	var dsi = death_screen.instantiate()
	dsi.get_node("Time").text = str(time) + " s"
	get_tree().root.add_child(dsi)

func collect_wisp():
	wisps += 1


func _on_walk_timer_timeout():
	if is_on_floor() and abs(velocity.x) > 0.1:
		print("play")
		$WalkSound.play()
