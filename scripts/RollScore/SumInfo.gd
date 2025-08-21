extends Area2D

@onready var sumInfo = $"../../../SumInfo"

func _mouse_enter():
	if !sumInfo.visible:
		sumInfo.visible = true

func _mouse_exit():
	if sumInfo.visible:
		sumInfo.visible = false
