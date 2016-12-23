local NPC_ID = 45000
local HOLY_LIGHT_RANK_2 = 639
local SEAL_OF_RIGHTEOUSNESS = 21084
local DEVOTION_AURA = 10290
local HAMMER_OF_JUSTICE = 853
local BLESSING_OF_MIGHT = 19740
local JUDGEMENT_OF_LIGHT = 20271
local ProtectionSpells = {498,1022,633}
local messages = {"STAGE 1 STARTED","Stage 1 SUCCESS","STAGE 1 FAILED"}

function HammerOfJustice(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if (Victim:IsCasting()) then
		creature:CastSpell(Victim, HAMMER_OF_JUSTICE, false)
	end

	creature:RemoveEvents()
end

function HolyLight(event, delay, repeats, creature)
	if (creature:GetHealthPct() < 45 and math.random(1, 100) >= 75 and not creature:IsCasting()) then
		creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
	end


end

function ProtectionLastPhase(event, delay, repeats, creature)
	local HealthPct = creature:GetHealthPct()
	local ObjKey = math.random(1,3)

	if (HealthPct <= 10 and not creature:HasAura(25771)) then
		creature:CastSpell(creature, ProtectionSpells[ObjKey], true)
		if (ProtectionSpells ~= 633 ) then
			creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
		end
	end
end

function JudgementOfLight(event, delay, repeats, creature)
	local Victim = creature:GetVictim();
	creature:CastSpell(Victim, JUDGEMENT_OF_LIGHT, false)
end

function AddAura(event, delay, repeats, creature)
	creature:CastSpell(creature,SEAL_OF_RIGHTEOUSNESS, false)
	creature:CastSpell(creature,BLESSING_OF_MIGHT, true)
	creature:CastSpell(creature,DEVOTION_AURA, true)
end

function openText(event, delay, repeats, creature)
	creature:SendUnitSay(messages[1],0)
end


function OnEnterCombat(event,creature)
	creature:RegisterEvent(openText,1500,1)
	creature:RegisterEvent(HolyLight,6000,0)
	creature:RegisterEvent(ProtectionLastPhase,2500,0)
	creature:RegisterEvent(AddAura,1000,1)
	creature:RegisterEvent(JudgementOfLight,9000,0)
	creature:RegisterEvent(HammerOfJustice,2500,0)
end

function OnLeaveCombat(event,creature)
	creature:RemoveEvents()
end

function OnDied(event,creature,killer)
 	killer:SendUnitSay(messages[4],0)
 	killer:Emote(21)
 	creature:RemoveEvents()
end

RegisterCreatureEvent(NPC_ID,1,OnEnterCombat);
RegisterCreatureEvent(NPC_ID,2,OnLeaveCombat);
RegisterCreatureEvent(NPC_ID,4,OnDied)