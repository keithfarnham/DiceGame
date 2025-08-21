extends OptionButton

@onready var faceValue = $"../FaceValue" as HSlider
@onready var faceValueNum = $"../ValueNum" as RichTextLabel
@onready var faceType = $"../FaceType" as OptionButton
@onready var numFaces = $"../../NumFaces" as HSlider
@onready var dieToModify = $"../../DieToModify" as OptionButton
# Called when the node enters the scene tree for the first time.
func _ready():
	item_selected.connect(on_select)
	for i in numFaces.value:
		add_item(str(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_select(index):
	if selected >= PlayerDice.DebugDie.faces.size():
		return
	if dieToModify.selected == 0:
		faceValue.value = PlayerDice.DebugDie.faces[selected].value
		faceValueNum = PlayerDice.DebugDie.faces[selected].value
		print("Modifying debug die w/ type " + str(DieFaceData.FaceType.keys()[PlayerDice.DebugDie.faces[selected].type]) + " index " + str(selected))
		faceType.select(PlayerDice.DebugDie.faces[selected].type)
	else:
		var dieIndex = dieToModify.selected - 1
		faceValue.value = PlayerDice.Dice[dieIndex].faces[selected].value
		faceValueNum = PlayerDice.Dice[dieIndex].faces[selected].value
		print("Modifying die " + str(dieIndex) + " with type" + str(DieFaceData.FaceType.keys()[PlayerDice.Dice[dieIndex].faces[selected].type]) + " index " + str(selected))
		faceType.select(PlayerDice.Dice[dieIndex].faces[selected].type)
