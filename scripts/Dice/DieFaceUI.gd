extends Button

class_name DieFaceUI

@onready var faceIndexUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceIndex/FaceIndexValue as Label
@onready var faceTypeUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceType/FaceTypeValue as Label
@onready var faceValueUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceValue/FaceValueValue as Label
@onready var panel = $AspectRatioContainer/Panel as Panel

var dieFaceData : DieFace
var faceIndex : int
var enableFocus : bool
var disableButton : bool

enum StyleBorderType
{
	SOURCE,
	TARGET
}

signal faceSelected(faceIndex : int)

func face_selected(faceIndex : int):
	faceSelected.emit(faceIndex)

func _pressed():
	Log.print("[DieFaceUI] Face " + faceIndexUI.text + " pressed. Should match faceIndex " + str(faceIndex))
	face_selected(faceIndex)

func _ready():
	faceIndexUI.text = str(faceIndex)
	faceTypeUI.text = str(DieFaceData.FaceType.keys()[dieFaceData.type])
	faceValueUI.text = DieFaceData.get_reward_name(dieFaceData.value) \
		if dieFaceData.type == DieFaceData.FaceType.REWARD else str(dieFaceData.value)
	focus_mode = Control.FOCUS_CLICK if enableFocus else Control.FOCUS_NONE
	disabled = disableButton
	
	var style
	match dieFaceData.type:
		DieFaceData.FaceType.SCORE:
			style = load("res://styleboxes/diefaces/score/scoreface_stylebox.tres") as StyleBoxFlat
			panel.add_theme_stylebox_override("panel", style)
		DieFaceData.FaceType.MULTIPLIER:
			style = load("res://styleboxes/diefaces/multiplier/multface_stylebox.tres") as StyleBoxFlat
			panel.add_theme_stylebox_override("panel", style)
		DieFaceData.FaceType.REWARD:
			style = load("res://styleboxes/diefaces/reward/rewardface_stylebox.tres") as StyleBoxFlat
			panel.add_theme_stylebox_override("panel", style)
	
func initialize(newFace : DieFace, newIndex : int, newEnableFocus := true):
	dieFaceData = newFace
	faceIndex = newIndex
	#disabling focus and disabling the button are coupled - don't think I'd ever want the button unfocusable but enabled or vice versa
	enableFocus = newEnableFocus
	disableButton = !newEnableFocus
	
func set_border_type(type : StyleBorderType):
	var style
	match type:
		StyleBorderType.SOURCE:
			style = load("res://styleboxes/diefaces/score/scoreface_stylebox_border_source.tres") as StyleBoxFlat
			panel.add_theme_stylebox_override("panel", style)
		StyleBorderType.TARGET:
			style = load("res://styleboxes/diefaces/score/scoreface_stylebox_border_target.tres") as StyleBoxFlat
			panel.add_theme_stylebox_override("panel", style)
