//For use in the cryogenic freezer. Makes you invincible while inside. See singulostation/code/game/machinery/cryopod.dm
/atom/movable/screen/alert/status_effect/cryo_protection
	name = "Cryogenic freeze"
	desc = "You are confined within the deep depths of the local cryogenic storage. Nothing there will be able to hurt you. Press this to eject yourself from cryogenic storage!"
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "cryo_protection"

/atom/movable/screen/alert/status_effect/cryo_protection/Click()
	if(isliving(usr))
		if (istype(usr.loc, /obj/machinery/computer/cryopod))
			var/obj/machinery/computer/cryopod/C = usr.loc
			C.eject_from_storage(usr)

/datum/status_effect/cryo_protection
	id = "cryo_protection"
	alert_type = /atom/movable/screen/alert/status_effect/cryo_protection

/datum/status_effect/cryo_protection/on_apply()
	owner.PermaCryoSleeping()
	owner.apply_status_effect(STASIS_MACHINE_EFFECT)
	owner.extinguish_mob()
	owner.status_flags |= GODMODE
	if(ishuman(owner))
		owner.reagents.clear_reagents()
	ADD_TRAIT(owner, TRAIT_PACIFISM, /datum/status_effect/cryo_protection)
	to_chat(owner,"<span class='warning'>You feel yourself rapidly entering cryostasis. It seems that nothing will be able to harm you within.")
	return ..()

//Copy pasted effects from on_apply since i don't wanna do tick() in on_apply and risk some sub-shenanigans happening
/datum/status_effect/cryo_protection/tick()
	//owner.status_flags |= GODMODE //In case any item/ status effects wearing off while in cryogenetic freeze causes GODMODE to disable.
	if(ishuman(owner))
		owner.reagents.clear_reagents() //Don't want smoke grenades or other shit doing stuff on the inhabitants
	if (!(istype(owner.loc, /obj/machinery/computer/cryopod))) // If the user escaped the cryopod through shenanigans
		owner.remove_status_effect(STATUS_EFFECT_CRYOPROTECTION) // Remove immortality if they escaped
	return ..()

/datum/status_effect/cryo_protection/on_remove()
	owner.status_flags &= ~GODMODE
	if(isliving(owner))
		owner.SetCryoSleeping(0 SECONDS)

	REMOVE_TRAIT(owner, TRAIT_PACIFISM, /datum/status_effect/cryo_protection)
	owner.visible_message("<span class='notice'>[owner] emerges from cryogenic freeze, waking from his slumber.</span>")
	to_chat(owner, "<span class='warning'>You emerge from your cryogenic slumber. You no longer feel protected.</span>")
