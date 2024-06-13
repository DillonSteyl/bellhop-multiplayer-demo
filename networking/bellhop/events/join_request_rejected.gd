class_name BellhopJoinRequestRejected
extends BellhopEvent

var host_connection_id: String
var reason: String


func update_from_content(content: Dictionary):
	host_connection_id = content["host_connection_id"]
	reason = content["reason"]


func _to_string() -> String:
	return "<BellhopJoinRequestRejected reason={reason}>".format({"reason": reason})
