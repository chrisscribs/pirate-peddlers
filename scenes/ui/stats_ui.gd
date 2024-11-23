class_name StatsUI
extends Control

@onready var card_count_label = %CardCountLabel
@onready var gold_label = %GoldLabel
@onready var sell_button = $VBoxContainer/SellButton

func update_card_count(card_count: int, card_type: String) -> void:
	if card_count > 0:
		card_count_label.text = str(card_count) + " X " + card_type
	else:
		card_count_label.text = "Empty"

func update_gold(gold: int) -> void:
	gold_label.text = str(gold)

func enable_sell_button(enabled: bool) -> void:
	sell_button.disabled = not enabled
