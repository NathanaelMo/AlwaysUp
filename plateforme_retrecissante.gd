extends StaticBody3D

@export var shrink_time : float = 2.0
@export var min_scale : float = 0.2
@export var reset_time : float = 0.2

var original_scale : Vector3
var shrinking : bool = false
var timer : float = 0.0

func _ready():
	original_scale = scale

func _process(delta):
	if shrinking:
		timer += delta
		var t = timer / shrink_time
		scale = original_scale.lerp(original_scale * min_scale, t)
		if timer >= shrink_time:
			shrinking = false
			timer = 0.0
	else:
		timer += delta
		if timer >= reset_time:
			scale = original_scale
			shrinking = true
			timer = 0.0