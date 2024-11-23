class_name PlayerStatsUI
extends StatsUI

@onready var player_gold_label = %PlayerGoldLabel
@onready var draw_pile_label = $HBoxContainer/DrawPile/DrawPileLabel

func update_draw_pile(card_count: int) -> void:
	draw_pile_label.text = str(card_count)

func update_gold(gold: int) -> void:
	player_gold_label.text = str(gold)
