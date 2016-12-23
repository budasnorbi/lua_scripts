local NPC_ID = 45000
local HOLY_LIGHT_RANK_2 = 639
local SEAL_OF_RIGHTEOUSNESS = 21084
local DEVOTION_AURA = 10290
local HAMMER_OF_JUSTICE = 853
local BLESSING_OF_MIGHT = 19740
local JUDGEMENT_OF_LIGHT = 20271
local ProtectionSpells = {498,1022,633}
local numbers = {"1","2","3"}

--Timer Function
function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
end

function HammerOfJustice(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if (Victim:IsCasting() and not creature:IsCasting()) then
		creature:CastSpell(Victim, HAMMER_OF_JUSTICE)
		if(not creature:HasSpellCooldown( JUDGEMENT_OF_LIGHT ))then
			creature:CastSpell(Victim, JUDGEMENT_OF_LIGHT, false)
		end
	end
end

function HolyLight(event, delay, repeats, creature)
	if (creature:GetHealthPct() < 50 and math.random(1, 100) >= 65 ) then
		creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
	end
end

function ProtectionLastPhase(event, delay, repeats, creature)
	local ObjKey = math.random(1,3)
	if (creature:GetHealthPct() <= 25 and not creature:HasAura(25771)) then
		creature:CastSpell(creature, ProtectionSpells[ObjKey], false)
		if (ProtectionSpells ~= 633) then
			creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
		end
	end
end

function JudgementOfLight(event, delay, repeats, creature)
	local Victim = creature:GetVictim();
	if(not creature:IsCasting())then
		creature:CastSpell(Victim, JUDGEMENT_OF_LIGHT, false)
	end
end

function AddAura(event, delay, repeats, creature)
	creature:CastSpell(creature,SEAL_OF_RIGHTEOUSNESS, false)
	creature:CastSpell(creature,BLESSING_OF_MIGHT, true)
	creature:CastSpell(creature,DEVOTION_AURA, true)
end

function deadText(event, delay, repeats, creature)
	creature:SendUnitSay("Now , you can loot my treasures",0)
	wait(1)
	creature:SendUnitSay("We meet each other at level 20",0)
end

--Gossip
function Gossip(event, player, unit)
	player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Are you ready for the duel ?", 0, 1)
    player:GossipSendMenu(1, unit)
end

function OnGossipSelect(event, player, unit, sender, intid, code)
	if(intid == 1) then
        unit:SendUnitSay("3",0)
        wait(1)
		unit:SendUnitSay("2",0)
		wait(1)
		unit:SendUnitSay("1",0)
		wait(1)
		unit:SendUnitSay("The duel is started!",0)
        unit:SetNPCFlags(0)
        unit:SetFaction(14)
        unit:AttackStart(player)
    end
end

--Events
function OnEnterCombat(event,creature)
	creature:RegisterEvent(HolyLight,6000,0)
	creature:RegisterEvent(ProtectionLastPhase,2500,0)
	creature:RegisterEvent(AddAura,1000,1)
	creature:RegisterEvent(JudgementOfLight,9000,0)
	creature:RegisterEvent(HammerOfJustice,1500,0)
end

function OnLeaveCombat(event,creature,killer)
	creature:RemoveEventById(16)
	creature:SetNPCFlags(1)
	creature:SetFaction(35)
	creature:RemoveEvents()
end

function OnDied(event,creature,killer)
	creature:RegisterEvent(deadText)
	creature:RemoveEvents()
end

RegisterCreatureGossipEvent(NPC_ID, 1, Gossip)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)

RegisterCreatureEvent(NPC_ID,1,OnEnterCombat);
RegisterCreatureEvent(NPC_ID,2,OnLeaveCombat);
RegisterCreatureEvent(NPC_ID,4,OnDied)