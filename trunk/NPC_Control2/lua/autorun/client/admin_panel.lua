//Woo, let's build some menu's!

local function BuildCP( panel )
  panel:AddControl( "Header", { Text = "NPC Control Server Settings" })
  panel:AddControl( "CheckBox", { Label = "NPC Protection", Command = "npc_control_npcprotect" })
  panel:AddControl( "CheckBox", { Label = "Allow NPC/Actor Spawning", Command = "npc_allow_spawning" })
  panel:AddControl( "CheckBox", { Label = "Allow players to move NPCs", Command = "npc_allow_moving" })
  panel:AddControl( "CheckBox", { Label = "Allow NPC-specific commands", Command = "npc_allow_specifics" })
  panel:AddControl( "CheckBox", { Label = "Allow players to make NPCs attack", Command = "npc_allow_attacking" })
  panel:AddControl( "CheckBox", { Label = "Players can tell NPCs to attack players", Command = "npc_allow_attacking_players" })
  panel:AddControl( "Label", {Text = ""})
  panel:AddControl( "CheckBox", { Label = "NPC Control is admin only", Command = "npc_adminonly" })
  panel:AddControl( "CheckBox", { Label = "Enable Episode 2 Content", Command = "npc_ep2content" })
  panel:AddControl( "Slider", { Label = "Max movement waypoints", Command = "sbox_maxwaypoints", min = 1, max = 1000 })
end

function npc_ControlAdmin()
  spawnmenu.AddToolMenuOption( "Utilities", "NPC Control", "Server Control", "Server Control", "", "", BuildCP, {} )
end
hook.Add( "PopulateToolMenu", "npc_addCP", npc_ControlAdmin )
