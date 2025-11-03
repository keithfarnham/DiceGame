extends Node

class_name DieFace

var type := DieFaceData.FaceType.score

var value

var chance

func _init(faceValue : int, faceType := DieFaceData.FaceType.score):
	type = faceType
	match type:
		DieFaceData.FaceType.score:
			value = faceValue
		DieFaceData.FaceType.multiplier:
			value = faceValue
		DieFaceData.FaceType.reward:
			value = faceValue as DieFaceData.RewardType
