class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25
const MAX_HAND_SIZE := 7

@export var hand: Hand

var player: PlayerStats

func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func start_game(player_stats: PlayerStats) -> void:
	player = player_stats
	player.draw_pile = player.deck.duplicate(true)
	player.draw_pile.shuffle()
	player.discard = CardPile.new()
	start_turn()

func start_turn() -> void:
	player.modifier = 0
	draw_cards(player.cards_per_turn)

func end_turn() -> void:
	hand.disable_hand()

func draw_card() -> bool:
	# Check if the hand is at max capacity
	if hand.get_children().size() >= MAX_HAND_SIZE:
		return false  # Stop drawing cards if hand is full

	reshuffle_deck_from_discard()

	# Check if there are cards left to draw
	if not player.draw_pile.empty():
		var card = player.draw_pile.draw_card()
		hand.add_card(card)
		reshuffle_deck_from_discard()
		return true  # Successfully drew a card
	else:
		print("No cards left to draw.")
		return false  # Could not draw a card

func draw_cards(amount: int) -> void:
	var cards_to_draw = amount

	# Adjust draw count to not exceed max hand size
	var current_hand_size = hand.get_children().size()
	if current_hand_size + amount > MAX_HAND_SIZE:
		cards_to_draw = MAX_HAND_SIZE - current_hand_size

	if cards_to_draw <= 0:
		print("Hand is already full; no cards drawn.")
		return

	# Use a tween to handle drawing cards visually
	var tween := create_tween()
	for i in range(cards_to_draw):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)

	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(player.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)

	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)

func reshuffle_deck_from_discard() -> void:
	if not player.draw_pile.empty():
		return

	while not player.discard.empty():
		player.draw_pile.add_card(player.discard.draw_card())

	player.draw_pile.shuffle()

func _on_card_played(card: Card) -> void:
	player.discard.add_card(card)
