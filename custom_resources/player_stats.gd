class_name PlayerStats
extends Stats

@export var starting_deck: CardPile
@export var cards_per_turn: int

var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

func can_play_card(card: Card) -> bool:
	return true

func create_instance() -> Resource:
	var instance: PlayerStats = self.duplicate()
	instance.gold = starting_gold
	instance.modifier = starting_modifier
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
