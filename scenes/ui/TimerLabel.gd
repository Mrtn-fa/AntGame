extends Label


var time = 0

func _ready():
	time = 0
	text = str(time)

func _process(delta):
	time += delta
	var seconds = fmod(time,60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	text = str_elapsed
