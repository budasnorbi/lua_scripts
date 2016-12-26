local NPC = 45001;
local BATTLE_STANCE = 2457;
local CHARGE = 100;
local HAMSTRING = 1715;
local HEROIC_STRIKE = 284;
local REND = 6546;
local THUNDER_CLAP = 6343;
local BATTLE_SHOUT = 6673;
local BLOODRAGE = 2687;
local texts = {
	"Now , you can loot my treasures",
	"We meet each other at level 20"
}

local TimerAi = require("Timer AI");
local GossipAI = require("Gossip AI");



--Add Auras 
function AddAura(event, delay, repeats, creature)
	creature:CastSpell(creature,BATTLE_STANCE, false)
	creature:CastSpell(creature,BATTLE_SHOUT, true)
end

function Charge(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if(not creature:IsRooted())then
		creature:CastSpell(Victim,CHARGE, true)
	end
end


function HeroicStrike(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if(creature:GetHealthPct() < 80 )then
		creature:CastSpell(Victim,CHARGE, false)
	end

end

function Bloodrage(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if(creature:GetHealthPct() <= 50) then
		creature:CastSpell(Victim,BLOODRAGE, false)
	end
end

function Rend(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if (creature:GetHealthPct() < 60 ) then
		creature:CastSpell(Victim,REND,false)
	end
end

function ThunderClap(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if(creature:GetHealthPct() < 5 )then
		creature:CastSpell(Victim,THUNDER_CLAP, true)
	end
end

function Hamstring(event, delay, repeats, creature)
	local Victim = creature:GetVictim()
	if(creature:GetHealthPct() <= 15 )then
		creature:CastSpell(Victim,HAMSTRING, false)
	end
end

--Events
function OnEnterCombat(event,creature)
	creature:RegisterEvent(AddAura,1500,1)
	creature:RegisterEvent(Charge,1000,0)
	creature:RegisterEvent(HeroicStrike,2500,0)
	creature:RegisterEvent(Rend,1000,0)
	creature:RegisterEvent(Bloodrage,1000,0)
	creature:RegisterEvent(ThunderClap,1000,0)
	creature:RegisterEvent(Hamstring,1000,0)
end

function OnLeaveCombat(event,creature,killer)
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
RegisterCreatureEvent(NPC,1,OnEnterCombat);
RegisterCreatureEvent(NPC,2,OnLeaveCombat);
RegisterCreatureEvent(NPC,4,OnDied)

--Create Gossip Events
RegisterCreatureGossipEvent(NPC, 1, Gossip)
RegisterCreatureGossipEvent(NPC, 2, OnGossipSelect)