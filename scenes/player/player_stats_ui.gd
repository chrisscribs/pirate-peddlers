class_name PlayerStatsUI
extends StatsUI

@onready var player_gold_label = %PlayerGoldLabel
@onready var draw_pile_label = $HBoxContainer/DrawPile/DrawPileLabel

var current_gold = 0

func _ready() -> void:
	Events.cards_sold.connect(_on_cards_sold)

func update_draw_pile(card_count: int) -> void:
	draw_pile_label.text = str(card_count)

func update_gold(gold: int) -> void:
	current_gold += gold
	player_gold_label.text = str(current_gold)

func _on_cards_sold(total_gold: int) -> void:
	update_gold(total_gold)
