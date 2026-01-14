extends Button

class_name DieUI

@onready var numFacesUI = $NumFaces as RichTextLabel
@onready var dieIndexUI = $DieIndex as RichTextLabel
@onready var dieTypeUI = $DieType as RichTextLabel

var GradientDefault = preload("res://gradients/default_gradient.tres")
var GradientMult = preload("res://gradients/multiplier_gradient.tres")
var GradientReward = preload("res://gradients/reward_gradient.tres")

var numFaces : int
var dieIndex : int
var dieData : Die

signal dieSelected(dieIndex : int)

func die_selected(selectedDie):
	dieSelected.emit(selectedDie)
	
func _ready():
	#@onready nodes aren't available until after the instance is added to the tree
	#so I init these values then assign them in here
	numFacesUI.text = str(numFaces)
	dieIndexUI.text = str(dieIndex)
	dieTypeUI.text = str(DiceData.DiceType.keys()[dieData.type])

func initialize(newDieData : Die, newIndex : int):
	dieData = newDieData
	numFaces = newDieData.num_faces()
	dieIndex = newIndex
	match newDieData.type:
		DiceData.DiceType.REWARD:
			icon.gradient = GradientReward
		DiceData.DiceType.SCORE:
			#TODO would be cool if the gradient was dependent on how many score/mult faces the die had
			icon.gradient = GradientDefault
			var multCount = 0
			for face in dieData.faces:
				if face.type == DieFaceData.FaceType.MULTIPLIER:
					multCount += 1
			if multCount == numFaces:
				icon.gradient = GradientMult

func _pressed():
	Log.print("[DieUI] Die " + dieIndexUI.text + " pressed. Should match dieIndex " + str(dieIndexUI.text.to_int()))
	die_selected(dieIndexUI.text.to_int())
