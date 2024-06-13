class_name BellhopLobbyStarted
extends BellhopEvent

var lobby_id: String


func update_from_content(content: Dictionary):
	lobby_id = content["lobby_id"]


func _to_string() -> String:
	return "<BellhopLobbyStarted lobby_id={lobby_id}>".format({"lobby_id": lobby_id})
