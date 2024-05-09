/obj/item/organ/internal/brain/synth
	var/obj/item/modular_computer/pda/synth/internal_computer
	actions_types = list(/datum/action/item_action/synth/open_internal_computer)

/obj/item/organ/internal/brain/synth/Initialize(mapload)
	. = ..()
	internal_computer = new(src)

/obj/item/organ/internal/brain/synth/Destroy()
	QDEL_NULL(internal_computer)
	return ..()

/obj/item/organ/internal/brain/synth/on_mob_insert(mob/living/carbon/brain_owner, special, movement_flags)
	. = ..()
	// Internal computer ID handling
	RegisterSignal(brain_owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equip_signal))
	RegisterSignal(brain_owner, COMSIG_HUMAN_UNEQUIPPED_ITEM, PROC_REF(on_unequip_signal))

	// Internal computer light handling
	RegisterSignal(brain_owner, COMSIG_ORGAN_IMPLANTED, PROC_REF(organ_add_signal))
	RegisterSignal(brain_owner, COMSIG_ORGAN_REMOVED, PROC_REF(organ_remove_signal))


/obj/item/organ/internal/brain/synth/on_mob_remove(mob/living/carbon/brain_owner, special)
	. = ..()
	// Internal computer ID handling
	UnregisterSignal(brain_owner, COMSIG_MOB_EQUIPPED_ITEM)
	UnregisterSignal(brain_owner, COMSIG_HUMAN_UNEQUIPPED_ITEM)

	// Internal computer light handling
	UnregisterSignal(brain_owner, COMSIG_ORGAN_IMPLANTED)
	UnregisterSignal(brain_owner, COMSIG_ORGAN_REMOVED)

/obj/item/organ/internal/brain/synth/proc/on_equip_signal(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	if(slot == ITEM_SLOT_ID)
		internal_computer.handle_id_slot(owner)

/obj/item/organ/internal/brain/synth/proc/on_unequip_signal(datum/source, obj/item/dropped_item, force, new_location)
	SIGNAL_HANDLER
	internal_computer.handle_id_slot(owner)

/obj/item/organ/internal/brain/synth/proc/organ_add_signal(obj/item/organ/implanted_organ, mob/living/carbon/receiver)
	SIGNAL_HANDLER
	internal_computer.handle_eye_check(implanted_organ, FALSE)

/obj/item/organ/internal/brain/synth/proc/organ_remove_signal(obj/item/organ/implanted_organ, mob/living/carbon/receiver)
	SIGNAL_HANDLER
	internal_computer.handle_eye_check(implanted_organ, TRUE)
