extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sprite2d = $Sprite2D

@export var jump_velocity : float = -400
@export var speed : float = 100
@export var can_attack : bool = false

var is_attacking : bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
    pass

func _process(delta):

    # Animation logic
    if not is_on_floor():
        velocity.y += gravity * delta
        if not is_attacking:
            if velocity.y < 0:
                animation_state.travel('jump_right')
            else:
                animation_state.travel('fall_right')
        else:
            animation_state.travel('Attack')
    elif not is_attacking:
        if velocity.x == 0:
            animation_state.travel('Idle')
        else:
            animation_state.travel('Run')
    else:
        pass

    # Input for jumping
    # if Input.is_action_just_pressed("jump") and is_on_floor():
    #     velocity.y = jump_velocity

    # Input for moving
    # var direction = Input.get_axis("ui_left", "ui_right")
    # if direction:
    #     if not is_attacking:
    #         velocity.x = direction * speed
    #         # Flip sprite if direction is negative
    #         if direction > 0:
    #             sprite2d.flip_h = false
    #         else:
    #             sprite2d.flip_h = true
    #     else:
    #         velocity.x = 0
    # else:
    #     # Travel animation to idle
    #     velocity.x = move_toward(velocity.x, 0, speed)

    # Input for attacking
    if Input.is_action_just_pressed("attack") and can_attack:
        animation_state.travel("Attack")

    move_and_slide()

func switch_attack_trigger():
    is_attacking = not is_attacking
    can_attack = false
