Scriptname GB_MagickFist_MonitorScript extends ActiveMagicEffect  
{Monitors actor for unarmed hits by the player, requires SKSE}

;cloak effect, which we'll check is active on the aggressor
MagicEffect Property MonitorCloakEffect Auto

;Enchantment effects to check for to determine which damage spell to apply
MagicEffect Property FireEnchEffect Auto
MagicEffect Property FrostEnchEffect Auto
MagicEffect Property ShockEnchEffect Auto
MagicEffect Property ParalyzeEnchEffect Auto
MagicEffect Property AbsorbEnchEffect Auto
MagicEffect Property ChaosEnchEffect Auto

;damage spells to be applied on hit, depending on which enchantments are active on the aggressor
Spell property FireSpell Auto
Spell property FrostSpell Auto
Spell property ShockSpell Auto
Spell property ParalyzeSpell Auto
Spell property AbsorbSpell Auto
Spell property ChaosSpell Auto

;Globals used to track effect magnitudes
GlobalVariable property FireMagnitude Auto
GlobalVariable property FrostMagnitude Auto
GlobalVariable property ShockMagnitude Auto
GlobalVariable property AbsorbMagnitude Auto
GlobalVariable property ParalyzeMagnitude Auto
GlobalVariable property ChaosMagnitude Auto

Actor MySelf

;bool Function IsMeleeHit(Form akSource, Projectile akProjectile)
;	Debug.Notification(akSource.GetName() + " (" + akSource.GetFormID() + ")")
;	If (akSource.GetFormID() == 500 && akProjectile == None)
;		return true
;	Else
;		return false
;	EndIf
;EndFunction

;bool Function IsEmptyHanded(Actor akActor)
;	If (akActor.getEquippedWeapon(true) == True || akActor.getEquippedWeapon(false) == True) 
;		Debug.Notification("Not empty handed: weapon")
;		Return false
;	ElseIf (akActor.getEquippedSpell(0) == True || akActor.getEquippedSpell(1) == True) 
;		Debug.Notification("Not empty handed: spell")
;		Return false
;	ElseIf (akActor.GetEquippedItemType(0) >= 7) 
;		Debug.Notification("Not empty handed: other")
;		Return false
;	Else 
;		Return true
;	EndIf
;EndFunction

bool Function IsUnarmedHit(Actor akActor, Form akSource, Projectile akProjectile, bool isBash)
	;return (IsEmptyHanded(akActor) && IsMeleeHit(akSource, akProjectile))

	If (akSource.GetFormID() == 500 && akProjectile == None && !isBash)
		return true
	Else
		return false
	EndIf
EndFunction


Event OnEffectStart(Actor akTarget, Actor akCaster)
	;Debug.Notification("Monitor effect start")
	MySelf = akTarget
	GoToState("alive")
EndEvent
 
State alive

	Event OnBeginState()
	;
	EndEvent

	Event OnUpdate()
	;
	EndEvent
 
	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		;Debug.Notification("Monitor effect expired")
		UnregisterForUpdate()
	EndEvent
 
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, \
  	 bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		;Debug.Notification("Hit registered")
		Actor attacker = (akAggressor as form) as actor
		;Check if attacker is player, has the cloak effect, and is fully unarmed
		if ((attacker == Game.GetPlayer()) && (attacker.HasMagicEffect(MonitorCloakEffect)) && (IsUnarmedHit(attacker, akSource, akProjectile, abBashAttack)) == true)
			;Debug.Notification("Unarmed strike done")
			;if attacker does have cloak effect and is fully unarmed, then check for specific things
			if (attacker.HasMagicEffect(FireEnchEffect))
				FireSpell.SetNthEffectMagnitude(0, FireMagnitude.GetValue())
				FireSpell.cast(MySelf)
				;Debug.Notification(FireMagnitude.GetValueInt() + " Fire damage")
			endif
			if (attacker.HasMagicEffect(FrostEnchEffect))
				FrostSpell.SetNthEffectMagnitude(0, FrostMagnitude.GetValue())
				FrostSpell.cast(MySelf)
				;Debug.Notification(FrostMagnitude.GetValueInt() + " Frost damage")
			endif
			if (attacker.HasMagicEffect(ShockEnchEffect))
				ShockSpell.SetNthEffectMagnitude(0, ShockMagnitude.GetValue())
				ShockSpell.cast(MySelf)
				;Debug.Notification(ShockMagnitude.GetValueInt() + " Shock damage")
			endif
			if (attacker.HasMagicEffect(ParalyzeEnchEffect))
				ParalyzeSpell.SetNthEffectDuration(0, ParalyzeMagnitude.GetValueInt())
				ParalyzeSpell.cast(MySelf)
				;Debug.Notification(ParalyzeMagnitude.GetValueInt() + "  paralyze time")
			endif
			if (attacker.HasMagicEffect(AbsorbEnchEffect))
				AbsorbSpell.SetNthEffectMagnitude(0, AbsorbMagnitude.GetValue())
				AbsorbSpell.cast(attacker, MySelf)
				;Debug.Notification(AbsorbMagnitude.GetValueInt() + "  Absorb damage")
			endif
			if (attacker.HasMagicEffect(ChaosEnchEffect))
				ChaosSpell.SetNthEffectMagnitude(0, ChaosMagnitude.GetValue())
				ChaosSpell.cast(MySelf)
				;Debug.Notification(ChaosMagnitude.GetValueInt() + " Chaos damage")
			endif
		endif
	EndEvent

	Event OnDying(Actor akKiller)
		UnregisterForUpdate()
		GoToState("dead")
	EndEvent
EndState

State dead
; Nothing needed here
EndState