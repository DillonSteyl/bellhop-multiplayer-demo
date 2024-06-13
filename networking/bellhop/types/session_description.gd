class_name SessionDescription
extends Resource

var session_type: String
var sdp: String


static func from_message(message: String) -> SessionDescription:
	var json = JSON.new()
	var err = json.parse(message)
	if err != OK:
		push_error("Error parsing JSON: " + str(err))
		return

	var data = json.data
	var description = SessionDescription.new()
	description.session_type = data["session_type"]
	description.sdp = data["sdp"]
	return description


func as_data() -> Dictionary:
	return {"session_type": session_type, "sdp": sdp}


func as_message() -> String:
	return JSON.stringify(as_data())


func _to_string():
	return "<SessionDescription session_type={st}>".format({"st": session_type})
