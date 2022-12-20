extends KinematicBody2D

enum {
	MOVE,
	UNHANDLED
};

export var speed : float = 100;
var velocity : Vector2 = Vector2.ZERO;
var states : int = MOVE;
onready var animation_tree : AnimationTree = $CollisionShape2D/AnimationTree;
onready var animation_state  = animation_tree.get("parameters/playback")

	
func _physics_process(_delta) -> void:
	
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
		velocity = direction;
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_state.travel("walk")
	else:
		animation_state.travel("idle")
		velocity = Vector2.ZERO
		
		
	velocity = move_and_slide(speed * velocity);	
		
