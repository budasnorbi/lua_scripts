local NPC_ID = 45000
local HOLY_LIGHT_RANK_2 = 639
local SEAL_OF_RIGHTEOUSNESS = 21084
local DEVOTION_AURA = 10290
local HAMMER_OF_JUSTICE = 853
local BLESSING_OF_MIGHT = 19740
local JUDGEMENT_OF_LIGHT = 20271
local ProtectionSpells = {498,1022,633}
local texts = {
	"Now , you can loot my treasures",
	"We meet each other at level 20",
	"The duel is started"
}

--Timer Function: can use inside every function . 
function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
end


-- SPELL TRIGGERS

--Hammer Of Justice: Only cast this spell if the victim is casting , but creature isn't casting.
--Bonus Funtion: If creature isn't cooldown on Judgement Of Light , it can combine these spell and combo then.
function HammerOfJustice(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if (Victim:IsCasting() and not creature:IsCasting()) then
		creature:CastSpell(Victim, HAMMER_OF_JUSTICE)
		if(not creature:HasSpellCooldown( JUDGEMENT_OF_LIGHT ))then
			creature:CastSpell(Victim, JUDGEMENT_OF_LIGHT, false)
		end
	end
end

--Holy Light : Only cast this spell , if the creature healt is lower than 50 and the random number is bigger or equal than 65
function HolyLight(event, delay, repeats, creature)
	if (creature:GetHealthPct() < 50 and math.random(1, 100) >= 65 ) then
		creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
	end
end

--Only use these spell if the creature health is under or equal than 25 and isn't has aura.
--Bug fix : If the create has aura , in this case doesn't cast ProtectionSpells .
--If the spell number is 3 from the generated random numbers , then Holy Light doesn't cast.
function ProtectionLastPhase(event, delay, repeats, creature)
	local ObjKey = math.random(1,3)
	if (creature:GetHealthPct() <= 25 and not creature:HasAura(25771)) then
		creature:CastSpell(creature, ProtectionSpells[ObjKey], false)
		if (ProtectionSpells ~= 633) then
			creature:CastSpell(creature, HOLY_LIGHT_RANK_2, false)
		end
	end
end

--JudgementOfLight: Cast victim target spell
--Bugfix:If the creature doesn't casting , this spell only will be use.
function JudgementOfLight(event, delay, repeats, creature)
	local Victim = creature:GetVictim();
	if(not creature:IsCasting())then
		creature:CastSpell(Victim, JUDGEMENT_OF_LIGHT, false)
	end
end

--Add Auras 
function AddAura(event, delay, repeats, creature)
	creature:CastSpell(creature,SEAL_OF_RIGHTEOUSNESS, false)
	creature:CastSpell(creature,BLESSING_OF_MIGHT, true)
	creature:CastSpell(creature,DEVOTION_AURA, true)
end

--Gossip function
function Gossip(event, player, unit)
	player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Are you ready for the duel ?", 0, 1)
    player:GossipSendMenu(1, unit)
end

--When the player selected this gossip item . These function will be activated .
function OnGossipSelect(event, player, unit, sender, intid, code)
	if(intid == 1) then
		player:GossipComplete()
        unit:SendUnitSay("3",0)
        wait(1)
		unit:SendUnitSay("2",0)
		wait(1)
		unit:SendUnitSay("1",0)
		wait(1)
		unit:SendUnitSay(texts[3],0)
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
	wait(1)
	creature:SendUnitSay(texts[1],0)
	wait(1)
	creature:SendUnitSay(texts[2],0)
	creature:RemoveEvents()
end

--Creature Events
RegisterCreatureEvent(NPC_ID,1,OnEnterCombat);
RegisterCreatureEvent(NPC_ID,2,OnLeaveCombat);
RegisterCreatureEvent(NPC_ID,4,OnDied)

--Create Gossip Events
RegisterCreatureGossipEvent(NPC_ID, 1, Gossip)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)