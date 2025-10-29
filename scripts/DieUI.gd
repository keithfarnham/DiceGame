extends Button
class_name DieUI

@onready var numFaces = $NumFaces as RichTextLabel
@onready var dieIndexUI = $DieIndex as RichTextLabel
@onready var dieTypeUI = $DieType as RichTextLabel

var dieData : Die
signal dieSelected(dieIndex : int)

func die_selected(selectedDie):
	dieSelected.emit(selectedDie)

func _pressed():
	print("[DieUI] Die " + dieIndexUI.text + " pressed. Should match dieIndex " + str(dieIndexUI.text.to_int()))
	die_selected(dieIndexUI.text.to_int())
