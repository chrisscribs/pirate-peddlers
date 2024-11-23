extends Card

var played_card = Card.new()

func apply_effects(targets: Array[Node]) -> void:
	played_card.id = self.id
	played_card.display_name = self.display_name
	played_card.one_coin_value = self.one_coin_value
	played_card.two_coin_value = self.two_coin_value
	played_card.three_coin_value = self.three_coin_value
	var add_to_dock_effect := AddToDockEffect.new(played_card)
	add_to_dock_effect.execute(targets)
