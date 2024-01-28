extends Node2D

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
    pass

func _process(_delta):

    # Get input of space key
    var space = Input.is_action_pressed("ui_select")
    # If space is pressed, travel animation to attack
    if space:
        animation_state.travel("Attack")


func back_to_idle():
    # When animation is finished, travel animation to idle
    print('Back to IDLE!')
    animation_state.travel("Idle")
