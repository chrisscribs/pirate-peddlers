class_name Dock
extends Node2D

@export var stats: Stats : set = set_dock_stats

@onready var arrow = $Arrow
@onready var stats_ui = $StatsUI as StatsUI

var current_placed_cards: CardPile

func set_dock_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_dock()

func update_dock() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func add_gold(gold: int) -> void:
	stats.earn_gold(gold)

func add_card_to_dock(card: Card) -> bool:
	# Initialize the card pile if it's not already created
	if not current_placed_cards:
		current_placed_cards = CardPile.new()
		
	if current_placed_cards.empty() or current_placed_cards.get_card(0).id == card.id:
		current_placed_cards.add_card(card)
		print("Added card %s to dock pile" % card.id)
		return true
		Events.card_placed_on_dock.emit(card)
	else:
		print("Cannot add card %s, dock already has %s" % [card.id, current_placed_cards.get_card(0).id])
		return false

func _on_area_entered(area):
	arrow.show()


func _on_area_exited(area):
	arrow.hide()
