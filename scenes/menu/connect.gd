extends Button

var PORT:int = 21057
@onready var lineEdit:LineEdit = $"../LineEdit"
@onready var multiplayerSetupNode: PontusMultiplayerNode = $"../../../MultiplayerSetup"

func _on_pressed() -> void:
	var userInput:String = lineEdit.text
	var port:int = PORT
	var ip:String = "127.0.0.1"
	if len(userInput) > 0:
		if text.find(":") != -1:
			ip = userInput.split(":")[0]
			port = userInput.split(":")[1] as int
		else:
			ip = userInput
	print(ip, port)
	multiplayerSetupNode.join_game(ip,port)
	pass # Replace with function body.
	
