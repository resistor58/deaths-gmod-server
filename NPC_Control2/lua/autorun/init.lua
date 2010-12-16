if SERVER then
   AddCSLua( "shared_cl.lua" )
   //AddCSLua( "shared.lua" )
   AddCSLua( "admin_panel.lua" )
   AddCSLua( "init_cl.lua" )
   AddCSLua( "custom_spawnlist.lua" )
   AddCSLua( "animpanel.lua" )

   cleanup.Register( "npc_waypoint" )
   MsgAll("NPC Control Content Loaded")
end