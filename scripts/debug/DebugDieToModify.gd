extends OptionButton

@onready var numFaces = $"../NumFaces" as HSlider
@onready var numFacesValue = $"../FacesNum" as RichTextLabel
@onready var faceToModify = $"../FaceDebugGrid/FaceToModify" as OptionButton
@onready var faceType = $"../FaceDebugGrid/FaceType" as OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	item_selected.connect(on_select)

func on_select(index):
	print("DieToModify selected " + str(selected))
	if selected == 0:
		PlayerDice.DebugDie = Die.new([], DiceData.DiceTypes.score)
	
	faceToModify.clear()
	for i in numFaces.value:
		faceToModify.add_item(str(i))
	numFacesValue.text = numFaces.value
	numFaces.value = PlayerDice.Dice[selected - 1].num_faces()
	faceType.select(PlayerDice.Dice[selected - 1].faces[0].type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	clear()
	add_item("Add New", 0)
	for i in PlayerDice.Dice.size():
		add_item(str(i), i)
