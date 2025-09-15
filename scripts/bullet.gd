extends Area3D

const SPEED = 20.0
var direction := Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(3.0).timeout
	if is_inside_tree():
		queue_free()

func _process(delta):
	global_position += direction * SPEED * delta

func _on_body_entered(body):
	print("hit: ", body.name)
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemy"):
		print("calling die")
		body.die()
		queue_free()
