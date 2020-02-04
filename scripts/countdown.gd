extends Node2D

export var name_countdown = 'timer1'
export var wait_time = '00:00:00'
export(bool) var auto_restart = false
var ended:bool = false
var seconds:int = 0

signal finish(_name_countdown)

func _ready():
	$timer.connect("timeout", self, "_on_timer_timeout")
	_start()

func _on_timer_timeout():
	if seconds >= 0:
		seconds -= 1
		_format()
	else:
		_finish()

func _format():
	if seconds >= 0:
		var f = common.formatSeconds(seconds)
		$label.text = str(f[0], ":", f[1], ":", f[2])

func _start(_wait_time = null, _restart = false):
	if _wait_time != null:
		wait_time = _wait_time
		
	if _restart:
		common.setCountdown(name_countdown, null)
		common.save_game()

	var current_timer = common.getCountdown(name_countdown)
	if current_timer is Dictionary:
		if current_timer.has("end"):
			var startDate = OS.get_datetime(true)
			var startSeconds = OS.get_unix_time_from_datetime(startDate)
			seconds = int(current_timer.end) - int(startSeconds)
			
			if seconds < 0:
				_finish()
				return
	else:
		_newTimer()
	
	ended = false
	_format()
	$timer.start()

func _newTimer()->void:
	var startDate = OS.get_datetime(true)
	var startSeconds = OS.get_unix_time_from_datetime(startDate)
	var addSeconds = common.formatTime2Seconds(wait_time)
	var endSeconds = int(startSeconds) + int(addSeconds)
	
	seconds = int(endSeconds) - int(startSeconds)
	
	common.setCountdown(name_countdown, {
		"start": int(startSeconds),
		"end": int(endSeconds)
	})
	common.save_game()

func _finish():
	ended = true
	emit_signal("finish", name_countdown)
	$timer.stop()
	
	if auto_restart:
		_start(wait_time, true)
