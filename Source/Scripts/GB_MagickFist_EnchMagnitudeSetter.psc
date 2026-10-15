Scriptname GB_MagickFist_EnchMagnitudeSetter extends ActiveMagicEffect  
{Sets the enchant effect's magnitude to a global variable; requires SKSE}

GlobalVariable Property magnitudeGlobal  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if (akTarget == Game.GetPlayer())
		magnitudeGlobal.SetValue(GetMagnitude())
	endif
EndEvent