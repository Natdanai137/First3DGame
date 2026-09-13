extends CharacterBody3D

@export var move_speed := 6.0
@export var jump_force := 6.0
@export var follow_lerp_factor := 5.0

var can_double_jump := false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2.0

@onready var model: Node3D = $Mako
@onready var gimbal: Node3D = %Gimbal
@onready var animation: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var is_grounded := is_on_floor()
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_vector.x, 0.0, input_vector.y).rotated(Vector3.UP, gimbal.rotation.y).normalized()
	var is_moving := direction.length_squared() > 0.01
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	if is_grounded:
		can_double_jump = true
	else:
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and (is_grounded or can_double_jump):
		velocity.y = jump_force
		AudioManager.jump_sfx.play()
		if not is_grounded:
			can_double_jump = false
	if is_moving:
		model.rotation.y = lerp_angle(model.rotation.y, Vector2(velocity.z, velocity.x).angle(), delta * 12.0)
	move_and_slide()
	update_animation(is_moving)
	gimbal.global_position = gimbal.global_position.lerp(global_position + Vector3.UP, delta * follow_lerp_factor)


func update_animation(is_moving: bool) -> void:
	# Keep the same four readable states as the original character controller.
	if not is_on_floor():
		animation.play("Jump" if velocity.y > 0.0 else "Flip", 0.12)
	elif is_moving:
		animation.play("Run", 0.12)
	else:
		animation.play("Idle", 0.18)
