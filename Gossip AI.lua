--Gossip function
function Gossip(event, player, unit)
	player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Are you ready for the duel ?", 0, 1)
    player:GossipSendMenu(1, unit)
end

--When the player selected this gossip item . These function will be activated .
function OnGossipSelect(event, player, unit, sender, intid, code)
	if(intid == 1 and unit:GetDisplayId() == 29785) then
		player:GossipComplete()
        unit:SendUnitSay("3",0)
        wait(1)
		unit:SendUnitSay("2",0)
		wait(1)
		unit:SendUnitSay("1",0)
		wait(1)
		unit:SendUnitSay("The duel is started",0)
        unit:SetNPCFlags(0)
        unit:SetFaction(14)
        unit:AttackStart(player)
    end

    if(intid == 1 and unit:GetDisplayId() == 29784 ) then
    	
		player:GossipComplete()
        unit:SendUnitSay("3",0)
        wait(1)
		unit:SendUnitSay("2",0)
		wait(1)
		unit:SendUnitSay("1",0)
		wait(1)
		unit:SendUnitSay("The duel is started",0)
        unit:SetNPCFlags(0)
        unit:SetFaction(14)
        unit:AttackStart(player)
    end
end
