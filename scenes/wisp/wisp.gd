extends CharacterBody2D

@onready var player = get_tree().root.get_node("Game/LavaMap/Player")

const SPEED = 8000
const RANGE = 500


func _ready():
	get_node("SubViewport/lb_wisp/AnimationPlayer").play("Action_001")
	get_node("SubViewport/lb_wisp/AnimationPlayer2").play("Action_002")


func _process(_delta):
	$SprWisp.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$SprWisp.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)


func _physics_process(delta):
	if abs(global_position - player.global_position).length() < RANGE:
		var dir: Vector2 = (global_position - player.global_position).normalized()
		velocity = dir * SPEED * delta
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _on_collection_radius_body_entered(body):
	if body.get_collision_layer_value(2):
		player.collect_wisp()
		queue_free()
