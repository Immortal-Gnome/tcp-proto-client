extends Node2D

const HOST: String = "51.20.64.237"
const PORT: int = 7000

@onready var client: Client = Client.new()

@onready var button: Button = %Button
@onready var label: Label = %Label

func _ready() -> void:
	add_child(client)
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	var res = await client.connect_to_host(HOST, PORT)
	print(res)
	label.text = res
