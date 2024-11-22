class_name StatsUI
extends HBoxContainer

@onready var gold = $Gold
@onready var gold_label = %GoldLabel
@onready var modifier = $Modifier
@onready var modifier_label = %ModifierLabel

func update_stats(stats: Stats) -> void:
	gold_label.text = str(stats.gold)
	modifier_label.text = str(stats.modifier)
	
	gold.visible = stats.gold >= 0
	modifier.visible = stats.modifier > 0
