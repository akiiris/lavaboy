extends Node2D

var other_door
@export var other_door_np: NodePath

func _ready():
	other_door = get_node(other_door_np)

func interact(user):
	print("I'm a door!")
	user.global_position = other_door.global_position

func _process(_delta):
	$Sprite2D.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$Sprite2D.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)


func _on_interact_area_area_entered(area):
	$SubViewport/DirectionalLight3D.light_energy = 3


func _on_interact_area_area_exited(area):
	$SubViewport/DirectionalLight3D.light_energy = 1
