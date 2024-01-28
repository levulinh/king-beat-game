extends Node2D

@export var animation_period : float = 2.
@export var progress = 0.

var current_time : float = 0.
@onready var MAIN_BAR_WIDTH = $MainBar.get('size').x
@onready var progress_dot = $ProgressDot

func _process(delta):
	progress += delta / animation_period
	if progress > 1:
		progress -= 1

	var progress_dot_x = MAIN_BAR_WIDTH * progress - MAIN_BAR_WIDTH / 2
	progress_dot.set('position', Vector2(progress_dot_x, progress_dot.get('position').y))
