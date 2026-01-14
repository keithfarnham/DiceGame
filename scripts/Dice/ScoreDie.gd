extends Die

class_name ScoreDie

func _init(faceData : Array[DieFace]):
	faces = faceData
	type = DiceData.DiceType.SCORE

func set_face(faceIndex: int, faceValue: int, faceType : DieFaceData.FaceType):
	assert(faceIndex < faces.size(), "[set_face] face index exceeds faces.size() - faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	Log.print("[set_face] updating faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	faces[faceIndex] = DieFace.new(faceValue, faceType)
