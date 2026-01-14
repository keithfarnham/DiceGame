extends Die

class_name RewardDie

func _init(faceData : Array[DieFace]):
	faces = faceData
	type = DiceData.DiceType.REWARD

func set_face(faceIndex: int, faceValue: int, faceType = DieFaceData.FaceType.REWARD):
	assert(faceIndex < faces.size(), "[RewardDie][set_face] face index exceeds faces.size() - faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	Log.print("[set_face] updating faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	faces[faceIndex] = DieFace.new(faceValue, faceType)
