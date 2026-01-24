extends Button

@onready 
var lineEdit = $"../LineEdit"
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_pressed() -> void:
	var ip = lineEdit.text
	print(ip)
	pass # Replace with function body.
