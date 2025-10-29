extends Node

class_name Die

var faces : Array[DieFace]
var type : DiceData.DiceTypes

func roll():
	#returns the face index, not the value or type
	return randi_range(0, faces.size() - 1)

func set_face(faceIndex: int, faceValue: int, faceType:= DieFaceData.FaceType.score):
	if faceIndex >= faces.size():
		print_rich("[color=red][set_face] something bad happen - faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType) + "[/color=red]")
	print("[set_face] updating faceIndex: " + str(faceIndex) + " faceValue: " + str(faceValue) + " faceType = " + str(faceType))
	faces[faceIndex] = DieFace.new(faceValue, faceType)

func num_faces() -> int:
	return faces.size()
	
func get_value_for_face(faceIndex) -> int:
	return faces[faceIndex].value
	
func get_type_for_face(faceIndex) -> DieFaceData.FaceType:
	return faces[faceIndex].type
	
func clear_faces():
	faces.clear()
	
func print():
	#TODO override the print so I can easily print the die's data
	pass

func _init(faceData : Array[DieFace], dieType : DiceData.DiceTypes):
	faces = faceData
	type = dieType
