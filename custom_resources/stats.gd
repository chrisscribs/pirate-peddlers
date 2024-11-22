class_name Stats
extends Resource

signal stats_changed

@export var starting_gold = 0
@export var max_gold = 999
@export var starting_modifier = 0
@export var max_modifier = 999

var gold: int : set = set_gold
var modifier: int : set = set_modifier

func set_gold(value: int) -> void:
	gold = clampi(value, 0, max_gold)
	stats_changed.emit()

func set_modifier(value: int) -> void:
	modifier = clampi(value, 0, max_modifier)
	stats_changed.emit()

func earn_gold(value: int) -> void:
	if value <= 0:
		return
	var initial_value = value
	value = clampi(value + modifier, 0, value)
	self.modifier = clampi(modifier + initial_value, 0, modifier)
	self.gold += value

func lose_gold(amount: int) -> void:
	self.gold -= amount

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.gold = starting_gold
	instance.modifier = starting_modifier
	return instance
