extends Node2D

const HOST: String = "192.168.1.235" # fazil - 51.20.64.237
const PORT: int = 7000

@onready var client: Client = Client.new()


@onready var connect_btn: Button = %ConnectBtn
@onready var setupgrid_btn: Button = %SetupGridBtn
@onready var color1_btn: Button = %Color1Btn
@onready var colorall_btn: Button = %ColorAllBtn
@onready var clear_btn: Button = %ClearBtn
@onready var label: Label = %Label

func _ready() -> void:
	add_child(client)
	connect_btn.pressed.connect(_on_connect_button_pressed)
	setupgrid_btn.pressed.connect(_on_setupgrid_button_pressed)
	color1_btn.pressed.connect(_on_color1_button_pressed)
	colorall_btn.pressed.connect(_on_colorall_button_pressed)
	clear_btn.pressed.connect(_on_clear_button_pressed)


func _on_connect_button_pressed() -> void:
	var res = await client.connect_to_host(HOST, PORT)
	print(res)
	label.text = res

func _on_setupgrid_button_pressed() -> void:
	pass
	
func _on_color1_button_pressed() -> void:
	pass
	
func _on_colorall_button_pressed() -> void:
	pass
	
func _on_clear_button_pressed() -> void:
	pass
