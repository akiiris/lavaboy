extends CharacterBody2D

const death_screen = preload("res://assets/menu/death_screen/death_screen.tscn")
const death_sound_scene = preload("res://scenes/player/player_death_sound.tscn")

@onready var model_anim = get_node("SubViewport/lava_boy_skeleton/AnimationPlayer")
const SPEED = 300.0
const JUMP_VELOCITY = -575.0
const BOOST_VELOCITY = -775.0
var coyote_time = 100
const JUMP_BUFFER_TIME = 50
var jump_buffer_time = -1

var direction: float = 1
var acceleration: float = 600
var deceleration: float = 3
var speed_cap: float = 300
var sprint_acceleration: float = 1200
var sprint_speed_cap: float = 600
var is_in_boost: bool = false
var sprinting: bool = false

var fastfall: bool = false
var fastfall_multiplier: float = 1.2

var last_on_floor: int = 0

var wisps: float = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	$SprPlayer.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$SprPlayer.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)
	
	
	# Lava death
	if global_position.y > 310:
		die()

func _physics_process(delta):
	move_player(delta)
	
	if direction == -1:
		$SprPlayer.flip_h = true
		$InteractArea/CollisionShape2D.position.x = -8
	else:
		$SprPlayer.flip_h = false
		$InteractArea/CollisionShape2D.position.x = 8
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
	
	if Input.is_action_just_pressed("interact"):
		for b in $InteractArea.get_overlapping_areas():
			if b.has_method("interact"):
				b.interact(self)
			elif b.get_parent().has_method("interact"):
				b.get_parent().interact(self)
	
	move_and_slide()
	
	


func move_player(delta):
	if is_on_floor():
		is_in_boost = false
	
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
	if not sprinting:
		if Input.is_action_pressed("left") and direction == -1:
			velocity.x -= acceleration * delta
		if Input.is_action_pressed("right") and direction == 1:
			velocity.x += acceleration * delta
	else:
		if Input.is_action_pressed("left") and direction == -1:
			velocity.x -= sprint_acceleration * delta
		if Input.is_action_pressed("right") and direction == 1:
			velocity.x += sprint_acceleration * delta
	
	if not is_in_boost:
		# Cap horizontal speed
		if not sprinting:
			if velocity.x > speed_cap:
				velocity.x = speed_cap
			if velocity.x < -speed_cap:
				velocity.x = -speed_cap
		else:
			if velocity.x > sprint_speed_cap:
				velocity.x = sprint_speed_cap
			if velocity.x < -sprint_speed_cap:
				velocity.x = -sprint_speed_cap
	
	if not sprinting:
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
	else:
		if not Input.is_action_pressed("left") or direction == 1:
			if velocity.x > -sprint_acceleration * deceleration * delta and velocity.x < 0:
				velocity.x = 0
			if velocity.x <= -sprint_acceleration * deceleration * delta:
				velocity.x += sprint_acceleration * deceleration * delta
		# Decelerate toward 0 when not holding right
		if not Input.is_action_pressed("right") or direction == -1:
			if velocity.x < sprint_acceleration * deceleration * delta and velocity.x > 0:
				velocity.x = 0
			if velocity.x >= sprint_acceleration * deceleration * delta:
				velocity.x -= sprint_acceleration * deceleration * delta
	
	# Coyote time
	if is_on_floor():
		last_on_floor = Time.get_ticks_msec()
	
	# Jump
	if Input.is_action_just_pressed("jump") and Time.get_ticks_msec() - last_on_floor <= coyote_time:
		velocity.y = JUMP_VELOCITY
		model_anim.play("jump")
	elif is_on_floor() and Time.get_ticks_msec() - jump_buffer_time < JUMP_BUFFER_TIME:
		velocity.y = JUMP_VELOCITY
		model_anim.play("jump")
	elif Input.is_action_just_pressed("jump"):
		jump_buffer_time = Time.get_ticks_msec()
	
	# Boost
	if Input.is_action_just_pressed("boost") and not is_on_floor() and wisps > 0:
		wisps -= 0.5
		velocity = BOOST_VELOCITY * Input.get_vector("right", "left", "down", "up")
		$BoostParticles.restart()
		is_in_boost = true
		model_anim.play("jump")
	
	# Sprint input
	if is_on_floor():
		sprinting = false
		if Input.is_action_pressed("boost"):
			sprinting = true
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Fastfall
	if Input.is_action_just_pressed("down") and not is_on_floor():
		fastfall = true
	if not Input.is_action_pressed("down") or is_on_floor():
		fastfall = false
	if fastfall:
		velocity.y += gravity * fastfall_multiplier * delta;

func die():
	var time = get_tree().root.get_node("Game/LavaMap").time_score_thing
	get_tree().root.get_node("Game/LavaMap").queue_free()
	var dsi = death_screen.instantiate()
	dsi.get_node("Time").text = str(time) + " s"
	get_tree().root.add_child(dsi)
	var dsoundi = death_sound_scene.instantiate()
	get_tree().root.add_child(dsoundi)
	
	

func collect_wisp():
	wisps += 1
	

func try_consume_wisp(num) -> bool:
	if wisps >= num:
		wisps -= num
		return true
	return false


func _on_walk_timer_timeout():
	if is_on_floor() and abs(velocity.x) > 0.1:
		$WalkSound.play()
