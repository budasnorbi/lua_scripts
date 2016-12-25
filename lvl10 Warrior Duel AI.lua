local NPC = 45001;
local BATTLE_STANCE = 2457;
local CHAREGE = 100;
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
end

--Events
function OnEnterCombat(event,creature)
	creature:RegisterEvent(AddAura,1000,1)
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