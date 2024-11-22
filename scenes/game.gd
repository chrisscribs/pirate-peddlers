extends Node2D

@export var player_stats: PlayerStats

@onready var game_ui = $GameUI
@onready var player_handler = $PlayerHandler
@onready var player = $Player

func _ready() -> void:
	var new_stats: PlayerStats = player_stats.create_instance()
	game_ui.player_stats = new_stats
	player.stats = new_stats
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(player_handler.start_turn)
	
	start_game(new_stats)

func start_game(stats: PlayerStats) -> void:
	player_handler.start_game(stats)
