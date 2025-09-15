extends CanvasLayer

var score_label
var health_label
var wave_label

func _ready():
	add_to_group("hud")
	score_label = get_node("ScoreLabel")
	health_label = get_node("HealthLabel")
	wave_label = get_node("WaveLabel")

func update_score(score):
	score_label.text = "Score: " + str(score)

func update_health(health):
	health_label.text = "Health: " + str(health)

func update_wave(wave):
	wave_label.text = "Wave: " + str(wave)
