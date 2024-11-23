class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = _set_card
@export var player_stats: PlayerStats

@onready var panel = $Panel
@onready var cost = $Cost
@onready var icon = $VBoxContainer/Icon
@onready var display_name = %DisplayName
@onready var drop_point_detector = $DropPointDetector
@onready var card_state_machine = $CardStateMachine
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()
@onready var one_coin_value = $ValueContainer/OneCoinValueContainer/OneCoinValue
@onready var two_coin_value = $ValueContainer/TwoCoinValueContainer/TwoCoinValue
@onready var three_coin_value = $ValueContainer/ThreeCoinValueContainer/ThreeCoinValue

var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false

signal reset_card_state

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> void:
	if not card:
		return
	
	# Check if any target's current_card_type matches the card's ID
	for target in targets:
		if not target.current_placed_cards or card.id == target.current_card_type:
			card.play([target])
			queue_free()
			return
		if card.id != target.current_card_type:
			_on_card_drag_or_aim_ended(self)


func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	if card.cost == 0:
		cost.hide()
	else:
		cost.text = str(card.cost)
		
	icon.texture = card.icon
	display_name.text = card.display_name
	one_coin_value.text = str(card.one_coin_value)
	two_coin_value.text = str(card.two_coin_value)
	three_coin_value.text = str(card.three_coin_value)

func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
		panel.add_theme_color_override("bg_color", Color(1, 1, 1, 0.5))
	else:
		cost.remove_theme_color_override("font_color")
		panel.remove_theme_color_override("bg_color")

func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value
	player_stats.stats_changed.connect(_on_player_stats_changed)

func _on_gui_input(event):
	card_state_machine.on_gui_input(event)

func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area):
	targets.erase(area)

func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true

func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = player_stats.can_play_card(card)
	Events.card_invalid_placement.emit()

func _on_player_stats_changed() -> void:
	self.playable = player_stats.can_play_card(card)
