extends Control

@onready var chooseDieButton = $ChooseDieButton as Button
@onready var confirmDialog = $ChooseDieConfirm as ConfirmationDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	chooseDieButton.pressed.connect(die_selected)
	confirmDialog.confirmed.connect(confirmed)
	confirmDialog.canceled.connect(cancelled)

func die_selected():
	confirmDialog.visible = true

func cancelled():
	confirmDialog.visible = false

func confirmed():
	print("[ChooseDieConfirm] Chose reward die + " + str($RewardGrid.ChosenDie.find_child("FaceIndexValue")))
	$RewardGrid.ChosenDie
	print("[ChooseDieConfirm] Switching Scene to RollScore")
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
