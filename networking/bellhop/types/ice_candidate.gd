class_name IceCandidate
extends Resource

var media: String
var index: int
var name: String


static func from_message(message: String) -> IceCandidate:
	var json = JSON.new()
	var err = json.parse(message)
	if err != OK:
		push_error("Error parsing JSON: " + str(err))
		return

	var data = json.data
	var candidate = IceCandidate.new()
	candidate.media = data["media"]
	candidate.index = data["index"]
	candidate.name = data["name"]
	return candidate


func as_data() -> Dictionary:
	return {"media": media, "index": index, "name": name}


func as_message() -> String:
	return JSON.stringify(as_data())


func _to_string():
	return "<IceCandidate: {msg}>".format({"msg": as_message()})
