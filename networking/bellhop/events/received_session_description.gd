class_name BellhopReceivedSessionDescription
extends BellhopEvent

var connection_id: String
var session_type: String
var sdp: String


func update_from_content(content: Dictionary):
	connection_id = content["connection_id"]
	session_type = content["session_type"]
	sdp = content["sdp"]


func _to_string() -> String:
	return "<BellhopReceivedSessionDescription connection_id={connection_id}>".format(
		{"connection_id": connection_id}
	)
