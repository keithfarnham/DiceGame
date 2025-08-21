extends Button

@onready var rollResultGrid = $"../RollResultGrid" as GridContainer
@onready var sumInfo = $"../SumInfo" as RichTextLabel
@onready var multInfo = $"../MultInfo" as RichTextLabel
@onready var continueButton = $"../Continue" as Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	print("Rolling Score dice")
	if !rollResultGrid.visible:
		rollResultGrid.visible = true
	var totalSum : int
	var preMultSum := 0
	var totalMult := 0
	sumInfo.text = ""
	multInfo.text = ""
	for die in PlayerDice.ScoreDice:
		var rolledIndex = die.roll()
		print("rolled index " + str(rolledIndex))
		match die.get_type_for_face(rolledIndex):
			DieFaceData.FaceType.score:
				print("rolling score " + str(die.get_value_for_face(rolledIndex)))
				preMultSum += die.get_value_for_face(rolledIndex)
				if sumInfo.text != "" :
					sumInfo.text += " + "
				sumInfo.text += str(die.get_value_for_face(rolledIndex))
			DieFaceData.FaceType.multiplier:
				print("rolling mult " + str(die.get_value_for_face(rolledIndex)))
				totalMult += die.get_value_for_face(rolledIndex)
				if multInfo.text != "":
					multInfo.text += " + "
				multInfo.text += str(die.get_value_for_face(rolledIndex))
			DieFaceData.FaceType.special:
				print("special")
				
	sumInfo.text += " = " + str(preMultSum)
	multInfo.text += " = " + str(totalMult)
	totalSum = preMultSum * totalMult
	var sumText := rollResultGrid.get_node("RollSum") as RichTextLabel
	sumText.text = str(preMultSum)
	var multText := rollResultGrid.get_node("RollMultValue") as RichTextLabel
	multText.text = str(totalMult)
	var totalText := rollResultGrid.get_node("RollResult") as RichTextLabel
	totalText.text = str(totalSum)
	print("rolled value: " + str(preMultSum) + " * " + str(totalMult) + " = " + str(totalSum))
	visible = false
	continueButton.visible = true
	if !rollResultGrid.visible:
		rollResultGrid.visible = true
