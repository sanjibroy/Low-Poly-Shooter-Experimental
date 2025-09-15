extends Node3D

@export var enemy_scene: PackedScene
var score = 0
var wave = 1
var enemies_per_wave = 3

func _ready():
	await get_tree().process_frame
	spawn_wave()

func spawn_wave():
	print("Wave: ", wave)
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.update_wave(wave)
	for i in range(enemies_per_wave):
		await get_tree().create_timer(0.5).timeout
		spawn_enemy()

func spawn_enemy():
	if enemy_scene == null:
		return
	
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	# Spawn at random position around the map edges
	var angle = randf() * TAU
	var distance = 12.0
	enemy.global_position = Vector3(cos(angle) * distance, 0, sin(angle) * distance)

func check_wave_complete():
	await get_tree().process_frame
	var enemies = get_tree().get_nodes_in_group("enemy")
	print("enemies remaining: ", enemies.size())
	if enemies.size() == 0:
		wave += 1
		enemies_per_wave += 2
		await get_tree().create_timer(2.0).timeout
		spawn_wave()
