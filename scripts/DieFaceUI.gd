extends Button

class_name DieFaceUI

@onready var faceIndexUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceIndex/FaceIndexValue as Label
@onready var faceTypeUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceType/FaceTypeValue as Label
@onready var faceValueUI = $AspectRatioContainer/Panel/CenterContainer/VBoxContainer/FaceValue/FaceValueValue as Label

var dieFaceData : DieFace

signal faceSelected(rewardType : DieFaceData.RewardType)

#TODO rewardType here might be too specific if i want other die face choices outside of RewardChoice
func face_selected(rewardType : int):
	faceSelected.emit(rewardType as DieFaceData.RewardType)

func _pressed():
	print("[DieFaceUI] Face " + faceIndexUI.text + " pressed. Should match faceIndex " + str(faceIndexUI.text.to_int()))
	face_selected(dieFaceData.value)
	
#func with_data(newFaceIndex : int, newType : DieFaceData.FaceType, newValue : int):
	#faceIndex.text = str(newFaceIndex)
	#type.text = str(DieFaceData.FaceType.keys()[newType])
	#value.text = str(newValue)
