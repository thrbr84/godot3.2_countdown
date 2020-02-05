extends Node2D
var colorOff = Color(.5,.07,.07,1)
var colorOn = Color(0,.5,0,1)

func _on_Countdown_start(_name_countdown):
	prints("start:", _name_countdown)
	if _name_countdown == "timer1":
		$buttons/btn1.self_modulate = colorOff
		
	if _name_countdown == "timer2":
		$buttons/btn2.self_modulate = colorOff
		
	if _name_countdown == "timer3":
		$buttons/btn3.self_modulate = colorOff
		
func _on_Countdown_finish(_name_countdown):
	prints("finish:", _name_countdown)
	if _name_countdown == "timer1":
		$buttons/btn1.self_modulate = colorOn
		
	if _name_countdown == "timer2":
		$buttons/btn2.self_modulate = colorOn
		
	if _name_countdown == "timer3":
		$buttons/btn3.self_modulate = colorOn

func _on_btn1_pressed():
	if $buttons/btn1/Countdown.ended:
		$buttons/btn1/Countdown._start("00:00:15", true) 
		prints('TAKE ITEM 1')

func _on_btn2_pressed():
	if $buttons/btn2/Countdown.ended:
		$buttons/btn2/Countdown._start(null, true) # restart the countdown with defined value
		
		# can restart with new time value
		#$btn2/countdown._start("00:01:00", true) 
		prints('TAKE ITEM 2')

func _on_btn3_pressed():
	if $buttons/btn3/Countdown.ended:
		$buttons/btn3/Countdown._start("00:00:15", true) 
		prints('TAKE ITEM FROM SERVER')
