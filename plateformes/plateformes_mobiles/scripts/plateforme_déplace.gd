extends StaticBody3D

@export var speed = 10.0
@export var distance = 15.0
@export var direction = Vector3(0, 0, 1)

var start_position = Vector3()
var target_position = Vector3()
var moving_forward = true
var velocity = Vector3.ZERO

func _ready():
    start_position = global_position
    target_position = start_position + direction * distance

func _process(delta):
    var previous_position = global_position
    var current_position = global_position
    
    if moving_forward:
        current_position = current_position.move_toward(target_position, speed * delta)
        if current_position.is_equal_approx(target_position):
            moving_forward = false
    else:
        current_position = current_position.move_toward(start_position, speed * delta)
        if current_position.is_equal_approx(start_position):
            moving_forward = true
    
    global_position = current_position
    velocity = (global_position - previous_position) / delta

func get_platform_velocity():
    return velocity