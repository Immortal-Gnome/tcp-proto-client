extends Node2D

const HOST: String = "127.0.0.1"
const PORT: int = 8080

@onready var client: Client = Client.new()

func _ready() -> void:
    add_child(client)
    client.connect_to_host(HOST, PORT)