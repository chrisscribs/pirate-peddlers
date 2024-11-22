class_name Player
extends Node2D

@export var stats: PlayerStats : set = set_player_stats

@onready var sprite_2d = $Sprite2D
@onready var stats_ui = $StatsUI as StatsUI

func set_player_stats(value: PlayerStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is PlayerStats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func add_gold(gold: int) -> void:
	stats.earn_gold(gold)
