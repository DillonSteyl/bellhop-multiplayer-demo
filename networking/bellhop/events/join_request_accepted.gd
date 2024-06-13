class_name BellhopJoinRequestAccepted
extends BellhopEvent

var host_connection_id: String
var peer_id: int


func update_from_content(content: Dictionary):
	host_connection_id = content["host_connection_id"]
	peer_id = content["peer_id"]


func _to_string() -> String:
	return (
		"<BellhopJoinRequestAccepted host_connection_id={host_connection_id}, peer_id={peer_id}>"
		. format({"host_connection_id": host_connection_id, "peer_id": peer_id})
	)
