extends Node2D

enum HALIGN { LEFT,CENTER,RIGHT }
enum VALIGN { BOTTOM,CENTER,TOP }

export var name_countdown = 'timer1'
export var wait_time = '00:00:00'
export var end_label = 'GET IT!'
export var unix_server = ''
export(Font) var font_label = null
export(HALIGN) var font_align = HALIGN.CENTER
export(VALIGN) var font_valign = VALIGN.CENTER
export(Vector2) var font_rect_size = Vector2(100,50)
export(Color) var font_color = Color(1,1,1,1)
export(bool) var auto_restart = false
var ended:bool = false
var seconds:int = 0
var startDate = OS.get_datetime(true)
var startSeconds = 0
var loaded = false

var timer = Timer.new()
var label = Label.new()
var http = HTTPRequest.new()

signal start(_name_countdown)
signal finish(_name_countdown)

func _ready():
	timer.connect("timeout", self, "_on_timer_timeout")
	http.connect("request_completed", self, "_on_http_request_completed")
	
	label.text = "00:00:00"
	label.add_font_override('font', font_label)
	
	if font_align == HALIGN.LEFT:
		label.align = HALIGN_LEFT
	elif font_align == HALIGN.CENTER:
		label.align = HALIGN_CENTER
	elif font_align == HALIGN.RIGHT:
		label.align = HALIGN_RIGHT
	
	if font_valign == VALIGN.BOTTOM:
		label.valign = VALIGN_BOTTOM
	elif font_valign == VALIGN.CENTER:
		label.valign = VALIGN_CENTER
	elif font_valign == VALIGN.TOP:
		label.valign = VALIGN_TOP
	
	label.rect_size = font_rect_size
	label.add_color_override("font_color", font_color)
	
	add_child(label)
	add_child(http)
	add_child(timer)
	
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
		label.text = str(f[0], ":", f[1], ":", f[2])

func _start(_wait_time = null, _restart = false):
	loaded = false
	if _wait_time != null:
		wait_time = _wait_time

	if _restart == true:
		common.setCountdown(name_countdown, null)
		common.save_game()
		
	_getDateTime()
	
func _initCountdown():
	if !loaded: return
	var current_timer = common.getCountdown(name_countdown)
	if current_timer is Dictionary:
		if current_timer.has("end"):
			seconds = int(current_timer.end) - int(startSeconds)
			if seconds < 0:
				_finish()
				return
	else:
		_newTimer()
	
	ended = false
	_format()
	timer.start()
	emit_signal("start", name_countdown)

func _newTimer()->void:
	var addSeconds = common.formatTime2Seconds(wait_time)
	var endSeconds = int(startSeconds) + int(addSeconds)
	
	seconds = int(endSeconds) - int(startSeconds)
	
	common.setCountdown(name_countdown, {
		"start": int(startSeconds),
		"end": int(endSeconds)
	})
	common.save_game()

func _finish():
	if !loaded: return
	ended = true
	emit_signal("finish", name_countdown)
	timer.stop()
	
	if end_label != "" and end_label!=null:
		label.text = str(end_label)
	
	if auto_restart == true:
		_start(wait_time, true)


func _getDateTime():
	if unix_server != '' and unix_server != null:
		var headers = ["Content-Type: text/plain"]
		http.request(unix_server, headers, true, HTTPClient.METHOD_GET)
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
				if ret != null and ret != '':
					startSeconds = int(ret)
					loaded = true
	
	_initCountdown()

