# hitbox.gd
extends Area3D
class_name Hitbox

@export var damage: float = 10.0

func _init()->void:
	# Connect the signal automatically
	var _err:int=area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D)->void:
	# This is the "Interface" check: if it's a Hurtbox, hit it
	print("Entered a node3D.")
	if area is Hurtbox:
		var hurtbox: Hurtbox = area
		print("Found Hurtbox")
		hurtbox.handle_hit(damage)
