extends Node2D

@onready var control_bar = $ControlBar
@onready var player_king = $PlayerKing
@onready var arrow_container = $ArrowContainer
@onready var correct_sfx = $CorrectSFX
@onready var wrong_sfx = $WrongSFX
@onready var pressed_sfx = $PressSFX
@onready var hit_message_box = $HitMessageBox
@onready var message_show_timer = $MessageShowTimer

var last_progress : float = 0.
var new_match_queue : int = 1
var is_in_match : bool = false
var _match = []
var current_inp_idx : int = 0
var can_attack : bool = false
var arrow_idx : int = 0
var arrow = preload('res://ControlUi/arrow.tscn')
var game_round : int = 8

func queue_free_arrows():
	for idx in arrow_container.get_child_count():
		arrow_container.get_child(idx).queue_free()

func create_match() -> Array:
	var num_arrows = round(game_round / 2.0)
	is_in_match = true
	player_king.set("can_attack", true)
	var __match = []
	queue_free_arrows()
	for i in range(num_arrows):
		__match.append(['right', 'right', 'up', 'down'][randi_range(0, 3)])
	var arrow_pos = - 30 * (num_arrows - 1)
	for i in range(num_arrows):
		var _arrow = arrow.instantiate()
		_arrow.set('position', Vector2(arrow_pos, 0))
		_arrow.set('direction', __match[i])
		arrow_pos += 60
		arrow_container.add_child(_arrow)
	return __match

func reset_match() -> void:
	is_in_match = false
	arrow_idx = 0
	_match.clear()
	new_match_queue = 2
	can_attack = false

func hit_submiss(message: String, is_wrong: bool) -> void:
	hit_message_box.set('text', message)
	message_show_timer.start()
	if is_wrong:
		wrong_sfx.play()
		player_king.set("can_attack", false)
	else:
		correct_sfx.play()
		game_round += 1
	queue_free_arrows()
	var arrow_pos = - 30 * 2
	for i in 3:
		var _arrow = arrow.instantiate()
		_arrow.set('state', 'wrong' if is_wrong else 'passed')
		_arrow.set('position', Vector2(arrow_pos, 0))
		_arrow.set('direction', 'right')
		arrow_pos += 60
		arrow_container.add_child(_arrow)
	reset_match()

func _process(_delta):
	var progress = control_bar.get('progress')

	# Check if at the start of the progress bar
	if progress < last_progress:
		new_match_queue -= 1
		if is_in_match:
			hit_submiss('TOO SLOW!', true)
		elif new_match_queue == 0:
			_match = create_match()
			print('DEBUG:', _match)

	if Input.is_action_just_pressed('attack'):
		if is_in_match:
			if can_attack:
				if 0.7 <= progress and progress <= 0.8:
					hit_submiss('PERFECT!', false)
				elif 0.6 <= progress and progress <= 0.9:
					hit_submiss('GREAT!', false)
				else:
					hit_submiss('MISS!', true)
				reset_match()
			else:
				hit_submiss('TOO EARLY!', true)
	last_progress = progress

func keycode_to_string(keycode : int) -> String:
	match keycode:
		KEY_LEFT:
			return 'left'
		KEY_RIGHT:
			return 'right'
		KEY_UP:
			return 'up'
		KEY_DOWN:
			return 'down'
		_:
			return ''

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode not in [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]:
			return
		else:
			if is_in_match:
				if not (_match.size() > 0 and arrow_idx == _match.size()):
					var key_need_match = _match[arrow_idx]
					var key_pressed = keycode_to_string(event.keycode)

					if key_pressed == key_need_match:
						if pressed_sfx.playing:
							pressed_sfx.stop()
						pressed_sfx.play()
						arrow_container.get_child(arrow_idx).set('state', 'correct')
						arrow_idx += 1
					else:
						hit_submiss('WRONG!', true)

				if _match.size() > 0 and arrow_idx == _match.size():
					print('DEBUG: Hit attack now!')
					can_attack = true


func _on_message_show_timer_timeout():
	hit_message_box.set('text', '')
