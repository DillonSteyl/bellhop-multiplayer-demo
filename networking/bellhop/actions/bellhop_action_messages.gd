class_name BellhopActionMessages
extends Object


static func start_lobby() -> String:
	var request = {"action": "start_lobby"}
	return JSON.stringify(request)


static func close_lobby() -> String:
	var request = {"action": "close_lobby"}
	return JSON.stringify(request)


static func join_lobby(lobby_id: String) -> String:
	var request = {
		"action": "join_lobby",
		"content":
		{
			"lobby_id": lobby_id,
		},
	}
	return JSON.stringify(request)


static func accept_join_request(player_connection_id: String, peer_id: int) -> String:
	var request = {
		"action": "accept_join_request",
		"content":
		{
			"player_connection_id": player_connection_id,
			"player_peer_id": peer_id,
		}
	}
	return JSON.stringify(request)


static func reject_join_request(
	player_connection_id: String,
	reason: String = "Because I can",
) -> String:
	var request = {
		"action": "reject_join_request",
		"content":
		{
			"player_connection_id": player_connection_id,
			"reason": reason,
		}
	}
	return JSON.stringify(request)


static func send_session_description(
	target_connection_id: String, session_description: SessionDescription
) -> String:
	var content = {
		"connection_id": target_connection_id,
	}
	content.merge(session_description.as_data())
	var request = {"action": "send_session_description", "content": content}
	return JSON.stringify(request)


static func send_ice_candidate(target_connection_id: String, ice_candidate: IceCandidate) -> String:
	var content = {
		"connection_id": target_connection_id,
	}
	content.merge(ice_candidate.as_data())
	var request = {"action": "send_ice_candidate", "content": content}
	return JSON.stringify(request)
