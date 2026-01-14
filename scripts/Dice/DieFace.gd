extends Node

class_name DieFace

var type : DieFaceData.FaceType
var value
var chance

func _init(faceValue : int, faceType := DieFaceData.FaceType.SCORE):
	type = faceType
	match type:
		DieFaceData.FaceType.SCORE:
			value = faceValue
		DieFaceData.FaceType.MULTIPLIER:
			value = faceValue
		DieFaceData.FaceType.REWARD:
			value = faceValue as DieFaceData.RewardType
