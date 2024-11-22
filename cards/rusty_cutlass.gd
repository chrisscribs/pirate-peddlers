extends Card

var played_card = Card.new()

func apply_effects(targets: Array[Node]) -> void:
	played_card.id = "rusty_cutlass"
	var add_to_dock_effect := AddToDockEffect.new(played_card)
	add_to_dock_effect.execute(targets)
