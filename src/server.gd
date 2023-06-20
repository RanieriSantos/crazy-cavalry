extends Node

var network = ENetMultiplayerPeer.new()
const port = 7000
const maxPlayers = 10

const userHandler = preload("res://src/userHandler.gd")

func _ready():
	start()

func start():
	network.create_server(port, maxPlayers)
	multiplayer.multiplayer_peer = network

@rpc("any_peer", "reliable")
func signin(clientId, nickname, password):
	print(clientId, nickname, password)

@rpc("any_peer", "reliable")
func signup(clientId, nickname, email, password):
	var user = userHandler.new()
	var err = user.signup(nickname, email, password)
	rpc_id(clientId, "signupAnswer", err)

@rpc("any_peer", "reliable")
func signupAnswer(_err):
	pass
