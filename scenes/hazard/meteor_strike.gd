extends Node2D

func _ready():
	$AnimationPlayer.play("strike_imminent")

func boom():
	for b in $Area2D.get_overlapping_bodies():
		if b.has_method("die"):
			b.die()
