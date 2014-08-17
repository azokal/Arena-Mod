-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheUnitByNameSync( "npc_dota_creature_boss_one", context )
    PrecacheModel( "npc_dota_creature_boss_one", context )
    PrecacheUnitByNameSync( "npc_dota_hero_axe", context )
    PrecacheModel( "npc_dota_hero_axe", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetGoldPerTick(0)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CAddonTemplateGameMode, 'OnNPCSpawned'), self)
	self.spawnBoss()
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonTemplateGameMode:OnNPCSpawned(tbl)
    local npc = EntIndexToHScript( tbl.entindex )
    if npc and npc:IsRealHero() and npc:GetLevel() == 1 then
        for _ = 1, 5 do
            npc:HeroLevelUp( false )
        end
        npc:SetGold(1000, false)
        --CreateHeroForPlayer("npc_dota_hero_axe_arena", npc:GetOwner())
    end
end

function CAddonTemplateGameMode:spawnBoss()
	local spawnLocation = Entities:FindByName( nil, "spawner_boss_one")
	local creature = CreateUnitByName( "npc_dota_creature_boss_one" , spawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
end
