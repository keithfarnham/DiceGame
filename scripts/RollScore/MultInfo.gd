extends Area2D

@onready var multInfo = $"../../../MultInfo"

func _mouse_enter():
	if !multInfo.visible:
		multInfo.visible = true

func _mouse_exit():
	if multInfo.visible:
		multInfo.visible = false
