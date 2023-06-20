extends Node

var network = ENetMultiplayerPeer.new()
const ip = "127.0.0.1"
const port = 7000
var clientId;

func _ready():
	connectToServer()

func connectToServer():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network
	multiplayer.connected_to_server.connect(connectionSucceeded)

func connectionSucceeded():
	clientId = multiplayer.get_unique_id()
	signup("toupeiru", "toupeira@astrq", "kekwasenha")

func connectionFailed():
	print("Failed to connect")

@rpc
func signin(nickname, password):
	rpc_id(1, "signin", clientId, nickname, password)

@rpc
func signup(nickname, email, password):
	rpc_id(1, "signup", clientId, nickname, email, password)

@rpc("any_peer", "reliable")
func signupAnswer(err):
	if err == ERR_ALREADY_IN_USE:
		print("esse garotinho existe")
	else:
		print("user created")
