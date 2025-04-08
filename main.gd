extends Node2D

const HOST: String = "192.168.1.236" # fazil - 51.20.64.237
const PORT: int = 7000

@onready var client: Client = Client.new()


@onready var connect_btn: Button = %ConnectBtn
@onready var disconnect_btn : Button = %DisconnectBtn
@onready var setupgrid_btn: Button = %SetupGridBtn
@onready var color1_btn: Button = %Color1Btn
@onready var colorall_btn: Button = %ColorAllBtn
@onready var clear_btn: Button = %ClearBtn
@onready var label: Label = %Label

func _ready() -> void:
	add_child(client)
	connect_btn.pressed.connect(_on_connect_button_pressed)
	disconnect_btn.pressed.connect(_on_disconnect_button_pressed)
	setupgrid_btn.pressed.connect(_on_setupgrid_button_pressed)
	color1_btn.pressed.connect(_on_color1_button_pressed)
	colorall_btn.pressed.connect(_on_colorall_button_pressed)
	clear_btn.pressed.connect(_on_clear_button_pressed)


func _on_connect_button_pressed() -> void:
	var res = await client.connect_client(HOST, PORT)
	print(res)
	label.text = res
	connect_btn.hide()
	disconnect_btn.show()
	
func _on_disconnect_button_pressed() -> void:
	var res = await client.disconnect_client()
	disconnect_btn.hide()
	connect_btn.show()


func _on_setupgrid_button_pressed() -> void:
	print("try_send_msg: SETUP GRID")
	await client.send_message(1)
	pass
	
	
func _on_color1_button_pressed() -> void:
	print("try_send_msg: COLOR RANDOM")
	await client.send_message(2)
	pass
	
	
func _on_colorall_button_pressed() -> void:
	print("try_send_msg: COLOR ALL")
	await client.send_message(3)
	pass
	
	
func _on_clear_button_pressed() -> void:
	print("try_send_msg: CLEAR GRID")
	await client.send_message(4)
	pass
