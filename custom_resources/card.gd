class_name Card
extends Resource

enum Type {ITEM, BONUS, EVENT}
enum Target {SELF, SINGLE_ITEM, ALL}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int = 0
@export var one_coin_value: int
@export var two_coin_value: int
@export var three_coin_value: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ITEM

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.SINGLE_ITEM:
			return tree.get_nodes_in_group("docks")
		Target.ALL:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("docks")
		_:
			return []
		

func play(targets: Array[Node]) -> void:
	Events.card_played.emit(self)
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))

func apply_effects(_targets: Array[Node]) -> void:
	pass
