extends CharacterBody2D

var turbo_sprite = preload("res://art/car_turbo.png")
var car_sprite = preload("res://art/car.png")

@export var wheel_base = 70 #Distance from front to rear wheel
@export var handling = 10 #how much steering decreases with speed
@export var steering_angle = 19 #Amount that front wheel turns, in degrees (output)
var drift_steer = 24 #steering angle while drifting
var regular_steer = 19 #steering angle while not drifting
@export var car_speed = 800 #engine power without turbo
var engine_power = 800
@export var turbo_power = 1500 #engine power with turbo

var test = 1
var steer_direction
var acceleration = Vector2.ZERO

@export var friction = -60
@export var drag = -0.06

@export var braking = -700
@export var max_speed_reverse = 200

@export var traction_drift = 1

@export var traction_normal = 25  # Regular traction
var traction = traction_normal


func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	#print(velocity.length())


func get_input():
	var turn = Input.get_axis("turn_left","turn_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	if Input.is_action_pressed("turbo"):
		engine_power = turbo_power
		$CarSprite.texture=turbo_sprite
	else: 
		engine_power = car_speed
		$CarSprite.texture = car_sprite
	print(engine_power)


func calculate_steering(delta):
	#Find the wheel positions
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	#Move the wheels forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	#Set the velocity and rotation to the new direction
	var new_heading = rear_wheel.direction_to(front_wheel)
#drift
	if Input.is_action_pressed("drift"):
		traction = traction_drift
		steering_angle = drift_steer
	else: 
		traction = traction_normal
		steering_angle = handling

	
	#reverse
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force


#make drift and turbo flexible so we only have to tweak "one number per action, per car
#interpolate drift tail
#add skid mark texture
#add grip zones on track based on underlag, or barriers
