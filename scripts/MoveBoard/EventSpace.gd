extends BoardSpace

class_name EventSpace

enum EventType
{
	SHOP,
	MONEY,
	ADD_DIE,
	ADD_REMOVE_FACE,
	PLUS_TO_FACE
}

var type : EventType

#because GDScript doesn't support overloading parent functions, if I need to add an initialize function to parent BoardSpace I will need to
#either have their args match or have different signatures i.e. different function name
func initialize(newIndex, newType):
	index = newIndex
	type = newType

func set_event_name_visible(isVisible : bool):
	$EventName.visible = isVisible

func set_type(newType : EventType):
	type = newType
	var eventName : String
	match type:
		EventType.SHOP:
			eventName = "SHOP"
		EventType.MONEY:
			eventName = "MONEY"
		EventType.ADD_DIE:
			eventName = "ADD DIE"
		EventType.ADD_REMOVE_FACE:
			eventName = "ADD/REMOVE FACE"
		EventType.PLUS_TO_FACE:
			eventName = "+1 TO FACE"
	$EventName.text = eventName
