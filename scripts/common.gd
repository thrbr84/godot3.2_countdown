extends Node

var file_path = "user://savegame.save"
var save_data = {}

func _ready():
	load_game()

func save_game()->void:
	var save_game = File.new()
	save_game.open(file_path, File.WRITE)
	save_game.store_var(save_data)
	save_game.close()

func load_game()->void:
	var save_game = File.new()
	if not save_game.file_exists(file_path):
		return

	save_game.open(file_path, File.READ)
	save_data = save_game.get_var()
	save_game.close()

func getCountdown(timer_name = '')->Dictionary:
	var ret = null
	if save_data is Dictionary:
		if save_data.has("countdown"):
			if save_data['countdown'].has(timer_name):
				ret = save_data['countdown'][timer_name]
	return ret
	
func setCountdown(timer_name = '', data = {})->void:
	if !save_data is Dictionary:
		save_data = {}
	
	if !save_data.has("countdown"):
		save_data['countdown'] = {}
		
	if !save_data['countdown'].has(timer_name):
		save_data['countdown'][timer_name] = {}
			
	save_data['countdown'][timer_name] = data

func formatSeconds(_seconds:int = 0)->Array:
	var second = floor(_seconds % 60)
	var minute = floor((_seconds / 60) % 60)
	var hour = floor(_seconds / 3600)
	return [
		str(hour) if hour >= 10 else str('0', hour), 
		str(minute) if minute >= 10 else str('0', minute), 
		str(second) if second >= 10 else str('0', second),
		]

func formatTime2Seconds(_time = "")->int:
	var s = _time.split(":")
	return (int(s[0]) * 3600) + (int(s[1]) * 60) + (int(s[2]))
