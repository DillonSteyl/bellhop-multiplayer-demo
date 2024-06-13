class_name BellhopEvent
extends Resource

const LOBBY_STARTED = "lobby_started"
const RECEIVED_JOIN_REQUEST = "received_join_request"
const JOIN_REQUEST_ACCEPTED = "join_request_accepted"
const JOIN_REQUEST_REJECTED = "join_request_rejected"
const RECEIVED_SESSION_DESCRIPTION = "received_session_description"
const RECEIVED_ICE_CANDIDATE = "received_ice_candidate"


## virtual method for generating event based on content
func update_from_content(_content: Dictionary):
	pass


static func create(event_type: String, content: Dictionary):
	var event: BellhopEvent
	match event_type:
		LOBBY_STARTED:
			event = BellhopLobbyStarted.new()
		RECEIVED_JOIN_REQUEST:
			event = BellhopReceivedJoinRequest.new()
		JOIN_REQUEST_ACCEPTED:
			event = BellhopJoinRequestAccepted.new()
		JOIN_REQUEST_REJECTED:
			event = BellhopJoinRequestRejected.new()
		RECEIVED_SESSION_DESCRIPTION:
			event = BellhopReceivedSessionDescription.new()
		RECEIVED_ICE_CANDIDATE:
			event = BellhopReceivedIceCandidate.new()
		_:
			push_error("Event type not recognized: " + event_type)
			return

	event.update_from_content(content)
	return event
