extends Control

@onready var debugUI = $DebugUI as Panel
@onready var hideDebug = $HideDebugUI as Button

@onready var dieToModify = $DebugUI/DieToModify as OptionButton
@onready var numFacesSlider = $DebugUI/NumFaces as HSlider
@onready var facesNumText = $DebugUI/FacesNum as RichTextLabel

@onready var faceToModify = $DebugUI/FaceDebugGrid/FaceToModify as OptionButton
@onready var faceType = $DebugUI/FaceDebugGrid/FaceType as OptionButton
@onready var faceValueSlider = $DebugUI/FaceDebugGrid/FaceValue as HSlider
@onready var faceValueNumText = $DebugUI/FaceDebugGrid/ValueNum as RichTextLabel

signal debug_print_grid

var DebugDie : Die

func _ready():
	debugUI.visible = false
	DebugDie = Die.new([], DiceData.DiceType.score)
	numFacesSlider.value = 6
	facesNumText.text = str(numFacesSlider.value)
	for i in numFacesSlider.value:
		DebugDie.faces.append(DieFace.new(i + 1))
		faceToModify.add_item(str(i))
		
	for type in DieFaceData.FaceType:
		faceType.add_item(str(type))
		
func _process(delta):
	if Input.is_action_just_pressed("ToggleDebug"):
		visible = !visible

func _on_add_die_pressed():
	print("trying to add die with " + str(numFacesSlider.value) + " faces")
	#PlayerDice.Dice.append(DebugDie)
	#var diceArrayIndex = PlayerDice.Dice.size() - 1
	#diceGrid.add_die(DebugDie, diceArrayIndex)
	PlayerDice.add_die(DebugDie)
	
	#reset faces
	var faces : Array[DieFace]
	for i in numFacesSlider.value:
		faces.append(DieFace.new(i + 1))
	#TODO if i want to debug add reward dice, I'll need to expand this
	DebugDie = Die.new(faces, DiceData.DiceType.score)

func _on_clear_all_dice_pressed():
	print(get_tree_string())
	#PlayerDice.remove_die()
	#TODO remove call to diceBag, either replace with contents of remove_all_dice() or make that func accessible from a more global place
	#PlayerDice.remove_all_dice()

func _on_delete_selected_die_pressed():
	#TODO this
	print(get_tree_string())
	#diceBag.remove_selected_die()

func _on_print_dice_array_pressed():
	print("PlayerDice:")
	PlayerDice.debug_print_dice_array()
	debug_print_grid.emit()
	#print("DiceGrid:")
	#var diceGrid = get_tree().get_first_node_in_group("SceneRoot").get_node("DiceUI").get_node("DiceGridScroll").get_node("DiceGrid") as DiceGrid

func _on_run_dice_choice_pressed():
	print("Changing Scene to ChooseDice")
	get_tree().change_scene_to_file("res://scenes/ChooseDice.tscn")

func _on_num_faces_value_changed(value):
	print("updating face slider value to " + str(value))
	facesNumText.text = str(value)
	
	if dieToModify.selected == 0:
		#cache current faces, clear array, and repopulate with cached faces + any extra new faces
		var oldFaces = DebugDie.faces
		DebugDie.faces.clear()
		faceToModify.clear()
		for i in value:
			faceToModify.add_item(str(i))
			if i >= oldFaces.size():
				DebugDie.faces.append(DieFace.new(i + 1))
				continue
			DebugDie.faces.append(oldFaces[i])

func _on_die_to_modify_item_selected(index):
	print("DieToModify selected " + str(dieToModify.selected))
	if dieToModify.selected == 0:
		DebugDie = Die.new([], DiceData.DiceType.score)
	
	faceToModify.clear()
	for i in numFacesSlider.value:
		faceToModify.add_item(str(i))
	facesNumText.text = numFacesSlider.value
	numFacesSlider.value = PlayerDice.Dice[dieToModify.selected - 1].num_faces()
	faceType.select(PlayerDice.Dice[dieToModify.selected - 1].faces[0].type)

func _on_die_to_modify_pressed():
	dieToModify.clear()
	dieToModify.add_item("Add New", 0)
	for i in PlayerDice.Dice.size():
		dieToModify.add_item(str(i), i)

func _on_face_to_modify_item_selected(index):
	if faceToModify.selected >= DebugDie.faces.size():
		return
	if dieToModify.selected == 0:
		faceValueSlider.value = DebugDie.faces[faceToModify.selected].value
		faceValueNumText = DebugDie.faces[faceToModify.selected].value
		print("Modifying debug die w/ type " + str(DieFaceData.FaceType.keys()[DebugDie.faces[faceToModify.selected].type]) + " index " + str(faceToModify.selected))
		faceType.select(DebugDie.faces[faceToModify.selected].type)
	else:
		var dieIndex = dieToModify.selected - 1
		faceValueSlider.value = PlayerDice.Dice[dieIndex].faces[faceToModify.selected].value
		faceValueNumText = PlayerDice.Dice[dieIndex].faces[faceToModify.selected].value
		print("Modifying die " + str(dieIndex) + " with type" + str(DieFaceData.FaceType.keys()[PlayerDice.Dice[dieIndex].faces[faceToModify.selected].type]) + " index " + str(faceToModify.selected))
		faceType.select(PlayerDice.Dice[dieIndex].faces[faceToModify.selected].type)

func _on_face_type_item_selected(index):
	print("selecting face type " + str(DieFaceData.FaceType.keys()[faceType.selected]) + " selected is " + str(faceType.selected as DieFaceData.FaceType))
	DebugDie.faces[faceToModify.selected].type = faceType.selected as DieFaceData.FaceType

func _on_hide_debug_ui_pressed():
	debugUI.visible = !debugUI.visible
	hideDebug.text = "HideDebug" if debugUI.visible else "ShowDebug"

func _on_face_value_value_changed(value):
	faceValueNumText.text = str(value)
	if faceToModify.selected < DebugDie.faces.size():
		DebugDie.faces[faceToModify.selected].value = value
