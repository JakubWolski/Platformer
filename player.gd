extends CharacterBody2D

const SPEED: float = 900.0
const JUMP_VELOCITY: float = -1500.0

var is_alive: bool = true

func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func die() -> void:
	if not is_alive:
		return
	is_alive = false
	print("You died")
	# Defer reloading the scene until after physics step ends
	call_deferred("_reload_scene")

func _reload_scene() -> void:
	get_tree().reload_current_scene()


func _on_spike_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()

func finish_level() -> void:
	print("Level complete!")

func _on_goal_body_entered(body: Node2D) -> void:
	if body.has_method("finish_level"):
		body.finish_level()
