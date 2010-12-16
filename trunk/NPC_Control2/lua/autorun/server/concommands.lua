if SERVER then
   CreateConVar("npc_control_npcprotect", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_spawning", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_moving", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_specifics", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_attacking", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_relations", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_actors", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_health", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_adminonly", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("npc_allow_attacking_players", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
   CreateConVar("sbox_maxwaypoints", "25", { FCVAR_REPLICATED, FCVAR_ARCHIVE })
end