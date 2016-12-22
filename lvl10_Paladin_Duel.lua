-- Holy
local NPC_ID = 45000
local HOLY_LIGHT_RANK_2 = 639
local SEAL_OF_RIGHTEOUSNESS = 21084
local DEVOTION_AURA = 10290
local HAMMER_OF_JUSTICE = 853
local BLESSING_OF_MIGHT = 19740
local JUDGEMENT_OF_LIGHT = 20271
local ProtectionSpells = {498,1022,633}

function HammerOfJustice(event, delay, repeats, creature)
	local Victim = creature:GetVictim();
	if(Victim:IsCasting())then
		creature:CastSpell(Victim, HAMMER_OF_JUSTICE, false)
	end
end


function HolyLight(event, delay, repeats, creature)
	if ( math.random(1, 100) >= 65 and creature:HealthPct() < 55 and not creature:IsCasting()) then
		creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
	end
end

function RandomSpell(event, delay, repeats, creature)
	local HealthPct = creature:GetHealthPct()
	local ObjKey = math.random(1,3)
	if HealthPct <= 10 then
		creature:CastSpell(creature, ProtectionSpells[ObjKey], true)
		if ProtectionSpells ~= 633 then
			creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
		end
	end
end

function JudgementOfLight(event, delay, repeats, creature)
	local Victim = creature:GetVictim();
	creature:CastSpell(Victim, JUDGEMENT_OF_LIGHT, false)
end

function AddAura(event, delay, repeats, creature)
	creature:CastSpell(creature,SEAL_OF_RIGHTEOUSNESS, true)
	creature:CastSpell(creature,BLESSING_OF_MIGHT, true)
	creature:CastSpell(creature,DEVOTION_AURA, true)
end

function OnEnterCombat(event,creature)
	creature:RegisterEvent(HolyLight,6000,0)
	creature:RegisterEvent(RandomSpell,2500,0)
	creature:RegisterEvent(AddAura,1000,2)
	creature:RegisterEvent(JudgementOfLight,9000,0)
	creature:RegisterEvent(HammerOfJustice,1000,0)
end

function OnLeaveCombat(event,creature)
	creature:RemoveEvents();
end

function OnDied(event, creature, killer)
 	creature:RemoveEvents();
end

RegisterCreatureEvent(NPC_ID,1,OnEnterCombat);
RegisterCreatureEvent(NPC_ID,2,OnLeaveCombat);
RegisterCreatureEvent(NPC_ID,4,OnDied)
