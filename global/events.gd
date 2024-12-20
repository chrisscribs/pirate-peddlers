extends Node

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested
signal card_placed_on_dock(card: Card)

# Player-related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
