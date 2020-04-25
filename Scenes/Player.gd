extends KinematicBody

onready var Camera = $Camera

onready var Terrain = get_node("/root/Game/Terrain")

var velocity = Vector3()
var gravity = -9.8
var speed = 0.1
var mouse_sensitivity = 0.002
var jump = 3
var jumping = false

var health = 100

func _ready():
	pass

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("Forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("Back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("Left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("Right"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_pressed("Jump"):
		jumping = true
	input_dir = input_dir.normalized()
	return input_dir


func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * speed
	
	Terrain.translation.x -= desired_velocity.x
	Terrain.translation.z -= desired_velocity.z

	if jumping and is_on_floor():
		velocity.y = jump
	jumping = false
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
	#and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
