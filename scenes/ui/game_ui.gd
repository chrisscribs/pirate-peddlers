class_name GameUI
extends CanvasLayer

@export var player_stats: PlayerStats : set = _set_player_stats

@onready var hand = $Hand
@onready var end_turn_button = %EndTurnButton
@onready var player_handler = $"../PlayerHandler"

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)

func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
	player_handler.start_turn()
