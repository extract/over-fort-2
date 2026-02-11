extends Projectile

var damage: float = 10


func _on_collision(_hitboxes: Array[Hitbox]) -> void:
	print("rocket hit something")
