extends CharacterBody3D

const SPEED = 6.0
@export var bullet_scene: PackedScene
var can_shoot = true
var health = 100
var score = 0
var hud = null

func _ready():
	await get_tree().process_frame
	hud = get_tree().get_first_node_in_group("hud")
	update_hud()

func _physics_process(delta):
	var input = Vector3.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")
	
	if input.length() > 0:
		input = input.normalized() * SPEED
	
	velocity.x = input.x
	velocity.z = input.z
	velocity.y -= 9.8 * delta
	
	move_and_slide()
	
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	var plane = Plane(Vector3.UP, global_position.y)
	var intersection = plane.intersects_ray(ray_origin, ray_dir * 100)
	
	if intersection:
		var direction = intersection - global_position
		direction.y = 0
		if direction.length() > 0.1:
			rotation.y = atan2(direction.x, direction.z) + deg_to_rad(90)

func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position + (-global_transform.basis.x * 1.2)
	bullet.direction = -global_transform.basis.x
	can_shoot = false
	await get_tree().create_timer(0.2).timeout
	can_shoot = true

func add_score(amount):
	score += amount
	update_hud()

func take_damage(amount):
	health -= amount
	update_hud()
	if health <= 0:
		die()

func die():
	call_deferred("_reload_scene")
	
func _reload_scene():
	get_tree().reload_current_scene()

func update_hud():
	if hud:
		hud.update_score(score)
		hud.update_health(health)
