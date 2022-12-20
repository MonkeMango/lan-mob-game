extends KinematicBody2D

enum {
	MOVE,
	UNHANDLED
};

export var speed : float = 100;
var velocity : Vector2 = Vector2.ZERO;
var states : int = MOVE;
onready var state_machine = $CollisionShape2D/AnimationTree.get("parameters/playback");

	
func _physics_process(delta) -> void:
	
	match states:
			
		MOVE:
			walk()
			
		UNHANDLED:
			pass
	
	
	
	
func walk() -> void:
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	);
	
	direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		state_machine.travel("walk_down")
		velocity = direction
	else:
		state_machine.travel("idle_down")
		velocity = Vector2.ZERO
		
	velocity = move_and_slide(speed * velocity);
