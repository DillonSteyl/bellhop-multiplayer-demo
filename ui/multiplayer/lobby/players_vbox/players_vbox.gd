class_name PlayersVBox
extends VBoxContainer

var player_labels: Dictionary = {}


func add_player(peer_id: int, player_info: PlayerInfo):
	var label = Label.new()
	label.text = player_info.player_name
	if peer_id == multiplayer.get_unique_id():
		label.text += " (You)"

	add_child(label)
	player_labels[peer_id] = label


func remove_player(peer_id):
	var label = player_labels.get(peer_id)
	if not label:
		return

	label.queue_free()
	player_labels.erase(peer_id)
