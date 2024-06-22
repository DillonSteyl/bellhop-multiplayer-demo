class_name BellhopLobbyCreationFailed
extends BellhopEvent

var reason: String


func update_from_content(content: Dictionary):
	reason = content["reason"]


func _to_string() -> String:
	return "<BellhopLobbyCreationFailed reason={reason}>".format({"reason": reason})
