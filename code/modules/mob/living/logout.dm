/mob/living/Logout()
	update_z(null)
	..()
	if(mind && mind.active)
		player_logged = TRUE
	else
		player_logged = FALSE
	if(!key && mind) //key and mind have become separated.
		mind.active = FALSE //This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
	med_hud_set_status()
