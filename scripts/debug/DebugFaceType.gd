extends OptionButton

@onready var faceToModify = $"../FaceToModify" as OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	item_selected.connect(on_select)
	for type in DieFaceData.FaceType:
		add_item(str(type))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_select(index):
	print("selecting face type " + str(DieFaceData.FaceType.keys()[selected]) + " selected is " + str(selected as DieFaceData.FaceType))
	PlayerDice.DebugDie.faces[faceToModify.selected].type = selected as DieFaceData.FaceType
