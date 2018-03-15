/obj/item/projectile/energy/net
	name = "energy netting"
	icon_state = "e_netting"
	damage = 10
	damage_type = STAMINA
	hitsound = 'sound/weapons/taserhit.ogg'
	range = 10
	var/obj/item/device/radio/beacon/projtarget

/obj/item/projectile/energy/net/Initialize()
	. = ..()
	SpinAnimation()
	set_projtarget()

/obj/item/projectile/energy/net/proc/set_projtarget()
	var/obj/item/ammo_casing/energy/net/N = loc
	if(istype(N))
		projtarget = N.drag.guntarget

/obj/item/projectile/energy/net/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/turf/Tloc = get_turf(target)
		if(!locate(/obj/effect/nettingportal) in Tloc)
			var/obj/effect/nettingportal/NP = new (Tloc)
			NP.teletarget = projtarget
	..()

/obj/item/projectile/energy/net/on_range()
	do_sparks(1, TRUE, src)
	..()

/obj/effect/nettingportal
	name = "DRAGnet teleportation field"
	desc = "A field of bluespace energy, locking on to teleport a target."
	icon = 'icons/effects/effects.dmi'
	icon_state = "dragnetfield"
	light_range = 3
	anchored = TRUE

/obj/effect/nettingportal/Initialize()
	. = ..()

	addtimer(CALLBACK(src, .proc/pop), 30)

/obj/effect/nettingportal/proc/pop()
	if(teletarget)
		var/TT = get_turf(teletarget)
		for(var/mob/living/L in get_turf(src))
			do_teleport(L, TT, 1)//teleport what's in the tile to the beacon
	else
		for(var/mob/living/L in get_turf(src))
			do_teleport(L, L, 15) //Otherwise it just warps you off somewhere.

	qdel(src)


/obj/effect/nettingportal/singularity_act()
	return

/obj/effect/nettingportal/singularity_pull()
	return

/obj/item/projectile/energy/trap
	name = "energy snare"
	icon_state = "e_snare"
	nodamage = 1
	knockdown = 20
	hitsound = 'sound/weapons/taserhit.ogg'
	range = 4

/obj/item/projectile/energy/trap/on_hit(atom/target, blocked = FALSE)
	if(!ismob(target) || blocked >= 100) //Fully blocked by mob or collided with dense object - drop a trap
		new/obj/item/restraints/legcuffs/beartrap/energy(get_turf(loc))
	else if(iscarbon(target))
		var/obj/item/restraints/legcuffs/beartrap/B = new /obj/item/restraints/legcuffs/beartrap/energy(get_turf(target))
		B.Crossed(target)
	..()

/obj/item/projectile/energy/trap/on_range()
	new /obj/item/restraints/legcuffs/beartrap/energy(loc)
	..()

/obj/item/projectile/energy/trap/cyborg
	name = "Energy Bola"
	icon_state = "e_snare"
	nodamage = 1
	knockdown = 0
	hitsound = 'sound/weapons/taserhit.ogg'
	range = 10

/obj/item/projectile/energy/trap/cyborg/on_hit(atom/target, blocked = FALSE)
	if(!ismob(target) || blocked >= 100)
		do_sparks(1, TRUE, src)
		qdel(src)
	if(iscarbon(target))
		var/obj/item/restraints/legcuffs/beartrap/B = new /obj/item/restraints/legcuffs/beartrap/energy/cyborg(get_turf(target))
		B.Crossed(target)
	QDEL_IN(src, 10)
	..()

/obj/item/projectile/energy/trap/cyborg/on_range()
	do_sparks(1, TRUE, src)
	qdel(src)
