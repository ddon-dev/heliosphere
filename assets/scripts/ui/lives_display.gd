extends Label

	
func set_lives_number(lives: int):
	if lives >= 0:
		text = "X %s" % lives
	else:
		text = "X DEAD"
