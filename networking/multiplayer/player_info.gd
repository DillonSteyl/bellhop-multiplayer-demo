class_name PlayerInfo
extends Resource

@export var player_name: String


static func from_json(json: Dictionary) -> PlayerInfo:
	var player_info = PlayerInfo.new()
	player_info.player_name = json["player_name"]
	return player_info


func as_json() -> Dictionary:
	return {"player_name": player_name}
