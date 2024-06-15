class_name RTCConnectionManager
extends Node

const CONFIG = {
	"iceServers":
	[
		{
			"urls":
			[
				"stun:stun1.l.google.com:19302",
				"stun:stun2.l.google.com:19302",
				"stun:stun3.l.google.com:19302",
				"stun:stun4.l.google.com:19302",
			],
		},
	]
}

@export var destination_connection_id: String
@export var destination_peer_id: int
@export var signalling_manager: SignallingManager

var connection = WebRTCPeerConnection.new()
var ice_candidate_queue: Array[BellhopReceivedIceCandidate] = []
var is_remote_description_set: bool = false


func _ready():
	var config = CONFIG.merged(Secrets.turn_servers_config)
	connection.initialize(config)
	connection.session_description_created.connect(_on_session_description_created)
	connection.ice_candidate_created.connect(_on_ice_candidate_created)


func _process(_delta):
	connection.poll()

	if is_remote_description_set and ice_candidate_queue.size() > 0:
		for ice_candidate in ice_candidate_queue:
			connection.add_ice_candidate(
				ice_candidate.media, ice_candidate.index, ice_candidate.name
			)
		ice_candidate_queue.clear()


func _on_ice_candidate_created(media: String, index: int, candidate_name: String):
	# Send the ICE candidate to the other connection via signaling server.
	var candidate = IceCandidate.new()
	candidate.media = media
	candidate.index = index
	candidate.name = candidate_name
	print("Generated candidate " + str(candidate))
	signalling_manager.send_ice_candidate(destination_connection_id, candidate)


func _on_session_description_created(type: String, sdp: String):
	# Set generated description as local.
	connection.set_local_description(type, sdp)

	# Send the session to other connection via signaling server.
	var session_description = SessionDescription.new()
	session_description.session_type = type
	session_description.sdp = sdp
	print("Generated session " + str(session_description))
	signalling_manager.send_session_description(destination_connection_id, session_description)


func _on_received_ice_candidate(event: BellhopReceivedIceCandidate):
	if event.connection_id != destination_connection_id:
		return
	ice_candidate_queue.append(event)


func _on_received_session_description(event: BellhopReceivedSessionDescription):
	if event.connection_id != destination_connection_id:
		return
	connection.set_remote_description(event.session_type, event.sdp)
	set_deferred("is_remote_description_set", true)
