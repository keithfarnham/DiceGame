extends Button

@onready var numFaces = $"../NumFaces" as HSlider
#@onready var diceGrid = $DiceGridScroll/DiceGrid as DiceGrid
#@onready var diceBag = get_tree().get_nodes_in_group("DiceBag")[0]

func _ready():
	for i in numFaces.value:
		PlayerDice.DebugDie.faces.append(DieFace.new(i + 1))

func _pressed():
	print("trying to add die with " + str(numFaces.value) + " faces")
	#PlayerDice.Dice.append(PlayerDice.DebugDie)
	#var diceArrayIndex = PlayerDice.Dice.size() - 1
	#diceGrid.add_die(PlayerDice.DebugDie, diceArrayIndex)
	PlayerDice.add_die(PlayerDice.DebugDie)
	
	#reset faces
	var faces : Array[DieFace]
	for i in numFaces.value:
		faces.append(DieFace.new(i + 1))
	#TODO if i want to debug add reward dice, I'll need to expand this
	PlayerDice.DebugDie = Die.new(faces, DiceData.DiceTypes.score)
