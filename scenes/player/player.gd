class_name Player
extends Node2D

@export var stats: PlayerStats : set = set_player_stats

@onready var sprite_2d = $Sprite2D
@onready var player_stats_ui = $PlayerStatsUI

func set_player_stats(value: PlayerStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_ui):
		stats.stats_changed.connect(update_ui)
	
	update_player()

func update_player() -> void:
	if not stats is PlayerStats:
		return
	if not is_inside_tree():
		await ready
	
	update_ui()

func update_ui() -> void:
	if player_stats_ui:
		player_stats_ui.update_gold(stats.gold)

func add_gold(gold: int) -> void:
	stats.earn_gold(gold)
	update_ui()
