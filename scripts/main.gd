extends Node2D

func _on_countdown_finish(_name_countdown):
	if _name_countdown == "timer1":
		$buttons/btn1.self_modulate = Color(0,.5,0,1)
		return
		
	if _name_countdown == "timer2":
		$buttons/btn2.self_modulate = Color(0,.5,0,1)
		return


func _on_btn1_pressed():
	if $buttons/btn1/countdown.ended:
		$buttons/btn1.self_modulate = Color(.5,.07,.07,1)
		$buttons/btn1/countdown._start("00:00:15", true) 
		prints('TAKE THE ITEM 1')

func _on_btn2_pressed():
	if $buttons/btn2/countdown.ended:
		$buttons/btn2.self_modulate = Color(.5,.07,.07,1)
		$buttons/btn2/countdown._start(null, true) # restart the countdown with defined value
		
		# can restart with new time value
		#$btn2/countdown._start("00:01:00", true) 
		prints('TAKE THE ITEM 2')
