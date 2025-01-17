/*				SECURITY OBJECTIVES				*/

/datum/objective/crew/enjoyyourstay
	explanation_text = "Welcome aboard. Enjoy your stay."
	jobs = "headofsecurity,securityofficer,warden,detective"
	var/list/edglines = list("Welcome aboard. Enjoy your stay.", "You signed up for this.", "Abandon hope.", "The tide's gonna stop eventually.", "Hey, someone's gotta do it.", "No, you can't resign.", "Security is a mission, not an intermission.")

/datum/objective/crew/enjoyyourstay/New()
	. = ..()
	update_explanation_text()

/datum/objective/crew/enjoyyourstay/update_explanation_text()
	. = ..()
	explanation_text = "Enforce Space Law to the best of your ability, and survive. [pick(edglines)]"

/datum/objective/crew/enjoyyourstay/check_completion()
	if(owner && owner.current)
		if(owner.current.stat != DEAD)
			return TRUE
	return FALSE

/datum/objective/crew/nomanleftbehind
	explanation_text = "Ensure no prisoners are left in the brig when the shift ends."
	jobs = "warden,securityofficer"

/datum/objective/crew/nomanleftbehind/check_completion()
	for(var/mob/living/carbon/M in GLOB.alive_mob_list)
		if(!(M.mind.assigned_role in GLOB.security_positions) && istype(get_area(M), /area/ship/security/prison)) //there's no list of incarcerated players, so we just assume any non-security people in prison are prisoners, and assume that any security people aren't prisoners
			return FALSE
	return TRUE
