#extends Node
#class_name DiceBag
#
#@onready var diceGrid = $"../DiceUI/DiceGridScroll/DiceGrid" as DiceGrid
#@onready var dieFaceGrid  = $"../DiceUI/DieFaceGrid" as GridContainer
#
##signal selectedDieUpdate
#var prevSelect := -1
#
#var dieUIScene = preload("res://scenes/DieUIScene.tscn")
#var dieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
#
##TODO this file can probably be broken up
#
#func add_dice(newDice : Array[Die]):
	#for die in newDice:
		#add_die(die)
#
#func add_die(newDie : Die):
	#print("[add_die] adding die with " + str(newDie.num_faces()) + " faces")
	##for i in newDie.num_faces():
		##print("[add_die] face [" + str(i) + "] of type " + str(DieFace.FaceType.keys()[newDie.get_type_for_face(i)]) + " with value " + str(newDie.get_value_for_face(i)))
#
	#PlayerDice.Dice.append(newDie)
	#var diceArrayIndex = PlayerDice.Dice.size() - 1
	#diceGrid.add_die(newDie, diceArrayIndex)
	#
	##TODO remove below and replace with call above
	##
	###setting up instance of DieUI
	##var diceArrayIndex = PlayerDice.Dice.size() - 1
	##var newDieUIInstance = dieUIScene.instantiate() as DieUI
	###newDieUIInstance.set("dieData" , newDie)
	##var numFacesNode = newDieUIInstance.find_child("NumFaces") as RichTextLabel
	##numFacesNode.text = str(newDie.num_faces())
	##
	##var dieIndexNode = newDieUIInstance.find_child("DieIndex") as RichTextLabel
	##dieIndexNode.text = str(diceArrayIndex)
	###newDieUIInstance.dieIndex = diceArrayIndex
	##newDieUIInstance.dieSelected.connect(die_selected)
	##diceGrid.add_child(newDieUIInstance)
#
#func clear_die_face_grid():
	#for childNode in dieFaceGrid.get_children():
		#dieFaceGrid.remove_child(childNode)
#
##func die_selected(dieIndex : int):
	##print("die_selected prev selected " + str(prevSelect) + " with die index " + str(dieIndex))
	##selectedDieUpdate.emit(dieIndex)
	##if prevSelect == dieIndex and dieFaceGrid.visible:
		###hide face UI and unfocus if reselecting the previously selected die
		##dieFaceGrid.visible = false
		##diceGrid.get_child(dieIndex).release_focus()
	##else:
		##dieFaceGrid.visible = true
		##
	##prevSelect = dieIndex
	##clear_die_face_grid()
	##for faceIndex in PlayerDice.Dice[dieIndex].num_faces():
		##var newFaceUIInstance = dieFaceUIScene.instantiate() as DieFaceUI
		##var faceIndexNode = newFaceUIInstance.find_child("FaceIndex") as RichTextLabel
		##faceIndexNode.text = str(faceIndex)
		##var typeNode = newFaceUIInstance.find_child("Type") as RichTextLabel
		##typeNode.text = str(DieFaceData.FaceType.keys()[PlayerDice.Dice[dieIndex].faces[faceIndex].type])
		##var valueNode = newFaceUIInstance.find_child("Value") as RichTextLabel
		##valueNode.text = str(PlayerDice.Dice[dieIndex].faces[faceIndex].value)
		##dieFaceGrid.add_child(newFaceUIInstance)
#
#func remove_die(dieIndexToRemove : int):
	#prevSelect = -1
	#PlayerDice.Dice.remove_at(dieIndexToRemove)
	#diceGrid.remove_child(diceGrid.get_child(dieIndexToRemove))
	#for i in diceGrid.get_children().size():
		#var a = diceGrid.get_children()[i] as DieUI
		#a.dieIndexUI.text = str(i)
	#for child in dieFaceGrid.get_children():
		#dieFaceGrid.remove_child(child)
#
#func remove_selected_die():
	#if prevSelect >= 0:
		#remove_die(prevSelect)
	#
#func remove_all_dice():
	##TODO remove diceBag find more global place to do this
	#for die in diceGrid.get_children():
		#diceGrid.remove_child(die)
	#for dieFace in dieFaceGrid.get_children():
		#dieFaceGrid.remove_child(dieFace)
		#PlayerDice.Dice.clear()
	#PlayerDice.Dice.clear()
	#
#func dice_grid_pre_sort():
	#print("about to sort die grid")
	##for die in diceGrid.get_children():
		#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#diceGrid.pre_sort_children.connect(dice_grid_pre_sort)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
