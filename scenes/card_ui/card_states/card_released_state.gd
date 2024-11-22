extends CardState

var played: bool

func enter() -> void:
	Events.card_invalid_placement.connect(on_card_invalid_placement)
	played = false
	
	if not card_ui.targets.is_empty():
		Events.tooltip_hide_requested.emit()
		played = true
		card_ui.play()

func on_input(_event: InputEvent) -> void:
	if played and not on_card_invalid_placement:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
