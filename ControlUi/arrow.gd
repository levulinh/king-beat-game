extends Node2D

@export var direction : String = "right"
@export var state : String = "unknown"

@onready var sprite = $Sprite2D

const WHITE_ARROW_REGION = Rect2(245, 2, 7, 12)
const BROWN_ARROW_REGION = Rect2(293, 2, 7, 12)
const WRONG_ICON_REGION = Rect2(243, 82, 10, 12)
const PASSED_ICON_REGION = Rect2(242, 67, 12, 11)

func _process(_delta):
    match direction:
        "right":
            self.set("rotation_degrees", 0)
        "left":
            self.set("rotation_degrees", 180)
        "up":
            self.set("rotation_degrees", -90)
        "down":
            self.set("rotation_degrees", 90)

    match state:
        "unknown":
            sprite.set('region_rect', WHITE_ARROW_REGION)
        "correct":
            sprite.set('region_rect', BROWN_ARROW_REGION)
        "wrong":
            sprite.set('region_rect', WRONG_ICON_REGION)
        "passed":
            sprite.set('region_rect', PASSED_ICON_REGION)
