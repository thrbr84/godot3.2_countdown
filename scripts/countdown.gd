extends Node2D

export var name_countdown = 'timer1'
export var wait_time = '00:00:00'
export var end_label = 'GET IT!'
export var unix_server = ''
export(bool) var auto_restart = false
var ended:bool = false
var seconds:int = 0
var startDate = OS.get_datetime(true)
var startSeconds = 0
var loaded = false

signal finish(_name_countdown)

func _ready():
	$timer.connect("timeout", self, "_on_timer_timeout")
	_start()

func _on_timer_timeout():
	if !loaded: return
	
	if seconds >= 0:
		seconds -= 1
		_format()
	else:
		_finish()

func _format():
	if !loaded: return
	
	if seconds >= 0:
		var f = common.formatSeconds(seconds)
		$label.text = str(f[0], ":", f[1], ":", f[2])

func _start(_wait_time = null, _restart = false):
	loaded = false
	if _wait_time != null:
		wait_time = _wait_time

	if _restart == true:
		prints(name_countdown, 'reset')
		common.setCountdown(name_countdown, null)
		common.save_game()
		
	_getDateTime()
	
func _initCountdown():
	var current_timer = common.getCountdown(name_countdown)
	if current_timer is Dictionary:
		if current_timer.has("end"):
			#var startDate = OS.get_datetime(true)
			#var startSeconds = OS.get_unix_time_from_datetime(startDate)
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
	#var startDate = OS.get_datetime(true)
	#var startSeconds = OS.get_unix_time_from_datetime(startDate)
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
	
	if end_label != "" and end_label!=null:
		$label.text = str(end_label)
	
	if auto_restart == true:
		prints(name_countdown, " auto restart")
		_start(wait_time, true)


func _getDateTime():
	if unix_server != '' and unix_server != null:
		var headers = ["Content-Type: text/plain"]
		$http.request(unix_server, headers, true, HTTPClient.METHOD_GET)
	else:
		startDate = OS.get_datetime(true)
		startSeconds = OS.get_unix_time_from_datetime(startDate)
		loaded = true
		_initCountdown()

func _on_http_request_completed(result, response_code, headers, body):
	var ret = null
	if unix_server != '' and unix_server != null:
		match result:
			HTTPRequest.RESULT_SUCCESS:
				ret = body.get_string_from_utf8()
				prints('SERVER:', ret)
	
	if ret == null or ret == '':
		prints('get date local')
		startDate = null #OS.get_datetime(true)
		startSeconds = -1 #OS.get_unix_time_from_datetime(startDate)
	else:
		prints('get date server')
		#startDate = ret
		startSeconds = int(ret)
	
	loaded = true
	_initCountdown()
