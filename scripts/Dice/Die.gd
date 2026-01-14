@abstract
class_name Die

var faces : Array[DieFace]
var type : DiceData.DiceType

func roll():
	#returns the face index, not the value or type
	return randi_range(0, faces.size() - 1)

@abstract
func set_face(faceIndex: int, faceValue: int, faceType : DieFaceData.FaceType)

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
