Scriptname dcc_msecg_EffectCollarSound extends ActiveMagicEffect
{attached to an enchantment which uses the IsMoving condition. when the wearer
is in motion it will make annoying cowbell sounds.}

Sound Property dcc_msecg_SoundCowbell Auto

;;    __  _______  ___   ___    _________ _      _____  ______   __
;;   /  |/  / __ \/ _ | / _ \  / ___/ __ \ | /| / / _ )/ __/ /  / /
;;  / /|_/ / /_/ / __ |/ , _/ / /__/ /_/ / |/ |/ / _  / _// /__/ /__
;; /_/  /_/\____/_/ |_/_/|_|  \___/\____/|__/|__/____/___/____/____/
;;

Event OnEffectStart(Actor who, Actor caster)
	self.OnUpdate()
	Return
EndEvent

Event OnUpdate()
	Actor who = self.GetTargetActor()

	;; default walking speeds.
	Float min = 0.5
	Float max = 1.25

	;; these conditions are sorted intentionally based on their scripting
	;; stress levels.

	If(who.IsSprinting())
		;; while sprinting you make a metric fucktonne more noise.
		min = 0.2
		max = 0.3
	ElseIf(who.IsRunning())
		;; while running you make a lot more noise.
		min = 0.3
		max = 0.75
	ElseIf(who.IsSneaking())
		;; you are a lot quieter while sneaking, with a chance to be completely
		;; silent based on your stealth skill.
		min = 1.0
		max = 2.0
		If((Utility.RandomFloat(1.0,100.0) * 0.75) < who.GetActorValue("Sneak"))
			;; congrats, your sneak skill saved you from making noise.
			self.RegisterForSingleUpdate(Utility.RandomFloat(min,max))
			Return
		EndIf
		;; right after sneaking you will still get this time delay before the
		;; next sound. in the event it chooses max time, consider this not a
		;; bug of the function but rather a feature - after sneaking you get
		;; a few steps in gracefully before you go all out being not-sneaky.
	EndIf


	dcc_msecg_SoundCowbell.Play(who)
	self.RegisterForSingleUpdate(Utility.RandomFloat(min,max))
	Return
EndEvent


