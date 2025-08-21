extends Button

@onready var debugUI = $"../DebugUI"

func _pressed():
	debugUI.visible = !debugUI.visible
	text = "HideDebug" if debugUI.visible else "ShowDebug"
