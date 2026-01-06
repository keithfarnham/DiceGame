extends BoardSpace

class_name EventSpace

enum event_type
{
	shop,
	#money,TODO re-enable money once shop is setup
	addDie,
	addRemoveFace
}

var type : event_type

#because GDScript doesn't support overloading parent functions, if I need to add an initialize function to parent BoardSpace I will need to
#either have their args match or have different signatures i.e. different function name
func initialize(newIndex, newType):
	index = newIndex
	type = newType

func set_event_name_visible(visible : bool):
	$EventName.visible = visible

func set_type(newType : event_type):
	type = newType
	var eventName : String
	match type:
		event_type.shop:
			eventName = "SHOP"
		#event_type.money: TODO re-enable money once shop is setup
			#eventName = "MONEY"
		event_type.addDie:
			eventName = "ADD DIE"
		event_type.addRemoveFace:
			eventName = "ADD/REMOVE FACE"
	$EventName.text = eventName
