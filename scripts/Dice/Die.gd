extends Node

class_name Die

var faces : Array[DieFace]
var type : DiceData.DiceType

func roll():
	#returns the face index, not the value or type
	return randi_range(0, faces.size() - 1)

func set_face(faceIndex: int, faceValue: int, faceType:= DieFaceData.FaceType.score):
	assert(faceIndex < faces.size(), "[set_face] something bad happened - faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	Log.print("[set_face] updating faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	faces[faceIndex] = DieFace.new(faceValue, faceType)

func num_faces() -> int:
	return faces.size()
	
func get_face(faceIndex) -> DieFace:
	return faces[faceIndex]
	
func get_value_for_face(faceIndex) -> int:
	return faces[faceIndex].value
	
func get_type_for_face(faceIndex) -> DieFaceData.FaceType:
	return faces[faceIndex].type
	
func clear_faces():
	faces.clear()
	
func print():
	Log.print("Die of type: " + str(DiceData.DiceType.keys()[type]) + " has " + str(num_faces()) + " faces")

func _init(faceData : Array[DieFace], dieType : DiceData.DiceType):
	faces = faceData
	type = dieType
