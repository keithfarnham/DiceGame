extends Button

class_name DieFaceUI

@onready var faceIndexUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceIndex/FaceIndexValue as Label
@onready var faceTypeUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceType/FaceTypeValue as Label
@onready var faceValueUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceValue/FaceValueValue as Label

var dieFaceData : DieFace
var faceIndex : int
var enableFocus : bool
var disableButton : bool

signal faceSelected(faceIndex : int)

func face_selected(faceIndex : int):
	faceSelected.emit(faceIndex)

func _pressed():
	print("[DieFaceUI] Face " + faceIndexUI.text + " pressed. Should match faceIndex " + str(faceIndex))
	face_selected(faceIndex)

func _ready():
	faceIndexUI.text = str(faceIndex)
	faceTypeUI.text = str(DieFaceData.FaceType.keys()[dieFaceData.type])
	faceValueUI.text = str(DieFaceData.RewardType.keys()[dieFaceData.value] \
		if dieFaceData.type == DieFaceData.FaceType.reward else dieFaceData.value)
	focus_mode = Control.FOCUS_CLICK if enableFocus else Control.FOCUS_NONE
	disabled = disableButton
	
func initialize(newFace : DieFace, newIndex : int, newEnableFocus := true):
	dieFaceData = newFace
	faceIndex = newIndex
	#disabling focus and disabling the button are coupled - don't think I'd ever want the button unfocusable but enabled or vice versa
	enableFocus = newEnableFocus
	disableButton = !newEnableFocus
