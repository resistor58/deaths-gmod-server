function npcc_doNotify( message, symbol, user )
  if SERVER then
    user:SendLua("GAMEMODE:AddNotify(\"" .. message .. "\", " .. symbol .. ", \"5\"); surface.PlaySound( \"ambient/water/drip" .. math.random(1, 4) .. ".wav\" )")
  end
end

function npcc_LimitControlCheck( ply, object, sayme )
  // Always allow in single player
   if (SinglePlayer()) then return true end
   if (object == nil) then return true end
   local tocheck = ""
   local c = GetConVarNumber("sbox_max" .. object)

   if ( ply:GetCount( object ) < c || c < 0 ) then
      return true
   else
      npcc_doNotify( "You've hit the " .. sayme .. " limit!", "NOTIFY_ERROR", ply )
      return false
   end
end

spawnednpcs = {} //spawnednpcs[entity] = player

function AdminCheck( ply, object )
  if (ply:IsAdmin() || SinglePlayer()) then return true end

  if (GetConVarNumber("npc_adminonly") == 1 && !SinglePlayer()) then
     ply:PrintMessage(HUD_PRINTTALK, object .. " is admin only on this server!")
     return false
  end
  return true
end

function NPCProtectCheck( ply, npc )
   if (ply:IsAdmin() || SinglePlayer()) then return true end
   if (GetConVarNumber("npc_control_npcprotect") == 0) then return true end

   if (spawnednpcs[npc] != ply && !SinglePlayer()) then
      if (!spawnednpcs[npc]:IsValid()) then return true end
      npcc_doNotify("That is not your NPC!", "NOTIFY_ERROR", ply)
      return false
   else
      return true
   end
end
