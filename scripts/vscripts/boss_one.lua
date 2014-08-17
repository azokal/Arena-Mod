--[[
	IA Boss One
	By Azokal
]]

require( "thread_core" )

prevLife = 0
prevAggro = 0
ThreadSys = {}

function Spawn( entityKeyValues )
	prevLife = thisEntity:GetHealth()
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25)
	ListenToGameEvent('entity_hurt', Hurt, self)
	ThreadSys = ThreadCore:Init()
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
		if (ThreadSys:GetTopOne() ~= prevAggro) then
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
				Target = ThreadSys:GetTopOne()
			}
			ExecuteOrderFromTable(order)
			prevAggro = ThreadSys:GetTopOne()
		end
       	return 0.25
end

function Hurt(tab)
	local ent = EntIndexToHScript(tab.entindex_killed)
	if ent == thisEntity then
		local atk = EntIndexToHScript(tab.entindex_attacker)
		local thread = 0
		if atk:GetClassname() == "npc_dota_hero_axe_arena" then
			thread = (prevLife - ent:GetHealth()) * 3
		else
			thread = (prevLife - ent:GetHealth())
		end
		prevLife = ent:GetHealth()
		ThreadSys:AddThead(tab.entindex_attacker, thread)
	end
end