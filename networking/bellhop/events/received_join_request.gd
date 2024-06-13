class_name BellhopReceivedJoinRequest
extends BellhopEvent

var connection_id: String


func update_from_content(content: Dictionary):
	connection_id = content["connection_id"]


func _to_string() -> String:
	return "<BellhopReceivedJoinRequest connection_id={connection_id}>".format(
		{"connection_id": connection_id}
	)
