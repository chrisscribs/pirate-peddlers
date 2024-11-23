class_name Dock
extends Node2D

@onready var arrow = $Arrow
@onready var stats_ui = $StatsUI as StatsUI
@onready var sell_button = $StatsUI/VBoxContainer/SellButton

var current_placed_cards: CardPile
var current_card_type: String = ""
var stats: Stats  

func _ready() -> void:
	if stats == null:
		var stats_instance = Stats.new()  # Create a new Stats instance
		set_dock_stats(stats_instance)  # Initialize stats via set_dock_stats
	
	sell_button.pressed.connect(self.sell_cards_in_dock)

# Set dock stats and connect signals
func set_dock_stats(value: Stats) -> void:
	# Ensure value is not null and create an instance of stats
	if value == null:
		return

	if stats != null:
		return

	stats = value.create_instance()
	if not stats:
		return

	stats.gold = 0  # Initialize gold to 0

	# Connect the stats_changed signal if it's not already connected
	if not stats.stats_changed.is_connected(_on_stats_changed):
		stats.stats_changed.connect(_on_stats_changed)

	update_dock()

# Update dock UI
func update_dock() -> void:
	if stats_ui and stats:
		stats_ui.update_gold(stats.gold)  # Update gold UI
		stats_ui.update_card_count(0, "None")  # Default to no cards

# Handle changes in stats
func _on_stats_changed(card: Card) -> void:
	if stats_ui and stats:
		# Get the card count from the current_placed_cards pile
		var card_count = current_placed_cards.cards.size() if current_placed_cards else 0
		# Update the stats UI with the new card count and current card type
		stats_ui.update_card_count(card_count, card.display_name)

# Add a card to the dock pile and update the dock
func add_card_to_dock(card: Card) -> bool:
	if not card:
		return false

	# Ensure stats is valid before using it
	if not stats:
		return false
	# Initialize the card pile if it doesn't exist
	if not current_placed_cards:
		current_placed_cards = CardPile.new()
	# Check if the card pile is empty or if the card matches the current pile type
	if current_placed_cards.empty() or current_placed_cards.get_card(0).id == card.id:
		current_placed_cards.add_card(card)
		current_card_type = card.id

		# Emit event when a card is placed on the dock
		Events.card_placed_on_dock.emit(card)

		# Recalculate gold based on the card
		calculate_gold(card)

		# Update stats after card is placed
		_on_stats_changed(card)

		# Enable/disable sell button based on whether the pile is empty
		stats_ui.enable_sell_button(not current_placed_cards.empty())
		return true
	else:
		return false

# Calculate gold based on card count and thresholds
func calculate_gold(card: Card) -> void:
	if not stats:
		return

	# Count how many times the card ID appears in the current pile
	var card_count = 0
	for c in current_placed_cards.cards:
		if c.id == card.id:
			card_count += 1
	# Calculate gold based on card count and thresholds
	var gold = 0
	if card_count >= card.three_coin_value:
		gold = 3
	elif card_count >= card.two_coin_value:
		gold = 2
	elif card_count >= card.one_coin_value:
		gold = 1
	# Update the gold value in stats and the UI
	stats.gold = gold
	stats_ui.update_gold(gold)

func sell_cards_in_dock() -> void:
	if not current_placed_cards or current_placed_cards.empty():
		return
	
	var total_gold = stats.gold
	
	stats.gold += total_gold
	stats_ui.update_gold(stats.gold)  # Update the UI with the new total gold

	current_placed_cards.empty()
	current_placed_cards.clear()
	current_card_type = ""
	stats_ui.update_card_count(0, "None")
	stats_ui.update_gold(0)
	stats_ui.enable_sell_button(false)
	
	Events.cards_sold.emit(total_gold)
	
	print("Sold cards for ", total_gold, " gold.")
	
