class_name BellhopReceivedIceCandidate
extends BellhopEvent

var connection_id: String
var media: String
var name: String
var index: int


func update_from_content(content: Dictionary):
	connection_id = content["connection_id"]
	media = content["media"]
	name = content["name"]
	index = content["index"]


func _to_string() -> String:
	return "<BellhopReceivedIceCandidate connection_id={connection_id}>".format(
		{"connection_id": connection_id}
	)
