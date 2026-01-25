extends Button

var PORT = 21057
@onready var lineEdit = $"../LineEdit"
@onready var multiplayerSetupNode = $"../../../MultiplayerSetup"
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_pressed() -> void:
	var userInput = lineEdit.text
	var port = PORT
	var ip = "127.0.0.1"
	if len(userInput) > 0:
		if text.find(":") != -1:
			ip = userInput.split(":")[0]
			port = int(userInput.split(":")[1])
		else:
			ip = userInput
	print(ip, port)
	multiplayerSetupNode.join_game(ip,port)
	pass # Replace with function body.
	
