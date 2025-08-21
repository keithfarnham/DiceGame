extends HSlider

#@onready var diceBag = $UI/DiceBag as DiceBag
@onready var dieToModify = $"../DieToModify" as OptionButton
@onready var faceNum = $"../FacesNum" as RichTextLabel
@onready var faceToModify = $"../FaceDebugGrid/FaceToModify" as OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	drag_ended.connect(update_value)
	value = 6
	faceNum.text = str(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_value(value_changed):
	if !value_changed:
		return
	print("updating face slider value to " + str(value))
	faceNum.text = str(value)
	
	if dieToModify.selected == 0:
		#cache current faces, clear array, and repopulate with cached faces + any extra new faces
		var oldFaces = PlayerDice.DebugDie.faces
		PlayerDice.DebugDie.faces.clear()
		faceToModify.clear()
		for i in value:
			faceToModify.add_item(str(i))
			if i >= oldFaces.size():
				PlayerDice.DebugDie.faces.append(DieFace.new(i + 1))
				continue
			PlayerDice.DebugDie.faces.append(oldFaces[i])
			
