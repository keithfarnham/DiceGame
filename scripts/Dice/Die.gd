@abstract
class_name Die

var faces : Array[DieFace]
var type : DiceData.DiceType

func roll():
	#returns the face index, not the value or type
	var sum = _sum_faces_roll_chance_weights()
	var r = randi_range(0, sum - 1)
	for index in range(faces.size()):
		var faceWeight = faces[index].chance
		if r < faceWeight:
			assert(index < faces.size(), "[Die] Rolled index is out of bounds")
			Log.print("[Die][roll] - random num chosen " + str(r) + " returning face index " + str(index))
			return index
		r -= faceWeight
	push_error("ERROR Die roll hit something we shouldn't")
	#return randi_range(0, faces.size() - 1)

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
	
func _sum_faces_roll_chance_weights():
	var sum = 0.0
	for face in faces:
		sum += face.chance
	return sum
