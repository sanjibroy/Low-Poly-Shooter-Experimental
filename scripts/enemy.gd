extends CharacterBody3D

const SPEED = 3.0
var player = null
var can_damage = true

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	velocity.y -= 9.8 * delta
	
	move_and_slide()
	
	if direction.length() > 0.1:
		rotation.y = atan2(direction.x, direction.z) + deg_to_rad(90)
	
	var distance = global_position.distance_to(player.global_position)
	if distance < 1.2 and can_damage:
		player.take_damage(10)
		can_damage = false
		var timer = get_tree().create_timer(1.0)
		await timer.timeout
		if is_inside_tree() and player and is_instance_valid(player):
			can_damage = true

func die():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.add_score(10)
	get_tree().get_root().get_node("World").check_wave_complete()
	queue_free()
