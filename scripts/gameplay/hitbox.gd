# hitbox.gd
extends Area3D
class_name Hitbox

@export var damage: float = 10.0

func _init():
	# Connect the signal automatically
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	# This is the "Interface" check: if it's a Hurtbox, hit it
	print("Entered a node3D.")
	if area is Hurtbox:
		print("Found Hurtbox")
		area.handle_hit(damage)
