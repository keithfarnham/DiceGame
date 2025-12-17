extends BoardSpace

class_name ItemSpace

enum item_type
{
	money,
	addDie,
	addRemoveFace
}

var type : item_type

#because GDScript doesn't support overloading parent functions, if I need to add an initialize function to parent BoardSpace I will need to
#either have their args match or have different signatures i.e. different function name
func initialize(newIndex, newType):
	index = newIndex
	type = newType

func set_item_name_visible(visible : bool):
	$ItemName.visible = visible

func set_type(newType : item_type):
	type = newType
	var itemName : String
	match type:
		item_type.money:
			itemName = "MONEY"
		item_type.addDie:
			itemName = "ADD DIE"
		item_type.addRemoveFace:
			itemName = "ADD/REMOVE FACE"
	$ItemName.text = itemName
