//TODO: LESS SLOPPY!


TOOL.Category = "NPC Control 2: Actors"
TOOL.Name = "Animations Control"
TOOL.Command = nil
TOOL.ConfigName = ""

include("shared.lua")
include("shared_cl.lua")

local queuednpcs = {{}}
local existingseqs = {{}}

/*if SERVER then
   numpad.Register( "animateNpc_key", animateNpc_key )
end*/

TOOL.ClientConVar["currentanim"] = ""
TOOL.ClientConVar["newqueuekey"] = "1"
TOOL.ClientConVar["currentgrp"] = ""

if (CLIENT) then
   language.Add("Tool_npc_actor_anims_name", "Actor Animations")
   language.Add("Tool_npc_actor_anims_desc", "Make Actor's Animate")
   language.Add("Tool_npc_actor_anims_0", "Left-Click to animate an Actor, Right-Click to queue them; Reload stops an actor from animating")
end

function AddQueue( ply, npc, animation, group, newkey )
   if (queuednpcs[ply] == nil) then queuednpcs[ply] = {} end
   if (queuednpcs[ply][npc] != nil) then
      queuednpcs[ply][npc] = nil
   end
   queuednpcs[ply][npc] = {anim = animation, grp = group}
   if SERVER then
     numpad.Register( "animateNpc_key", animateNpc_key )
     local newindex = numpad.OnDown(ply, newkey, "animateNpc_key", npc)
     queuednpcs[ply][npc].numindex = newindex
   end
end

function animateNpc_key( ply, args1 ) //Numpad
   if (args1 != nil) then
     if SERVER then
        if (queuednpcs[ply][args1] != nil) then
           animateNpc( ply, queuednpcs[ply][args1].grp, queuednpcs[ply][args1].anim, args1 )
        end
     end
   end
end

function animateNpc( ply, currentgrp, currentanim, npc )
   if (npc != nil) then
   //Whoops! I don't know how to remove my numpad key efficiently
   //Email me please Benjy355@gmail.com

     if (existingseqs[ply] == nil) then existingseqs[ply] = {} end
     if (existingseqs[ply][npc] != nil) then
        existingseqs[ply][npc]:SetName("")
        existingseqs[ply][npc]:Fire("Kill", "", 0)
        existingseqs[ply][npc] = nil
     end
     npc:SetName(ply:GetName() .. "_animateme" .. npc:EntIndex())
     local sequence = ActorAnims[currentgrp][currentanim]
     local newseq = ents.Create("scripted_sequence")
     newseq:SetKeyValue("m_fMoveTo", "0")
     newseq:SetKeyValue("m_bLoopActionSequence", "1")
     newseq:SetKeyValue("m_iszEntity", npc:GetName())
     if (sequence.seq != "") then newseq:SetKeyValue("m_iszEntry", sequence.seq) end
     if (sequence.post != "") then newseq:SetKeyValue("m_iszPlay", sequence.post) else newseq:SetKeyValue("m_iszPlay", "idle") end
     newseq:SetKeyValue("spawnflags", "4288")
     newseq:SetPos(Vector(0,0,0))
     newseq:SetKeyValue("targetname", ply:GetName() .. "_sequence_" .. npc:EntIndex())
     newseq:Spawn()
     newseq:Fire("BeginSequence", "", 0)
     existingseqs[ply][npc] = newseq
   
   end
end

function TOOL:LeftClick( trace )
   if SERVER then
   local dohalt = false
   if (GetConVarNumber("npc_allow_actors") != 1 && !SinglePlayer()) then
      self:GetOwner():PrintMessage(HUD_PRINTTALK, "Actor Animating is not allowed on this server")
      dohalt = true
   end
   if (!AdminCheck(self:GetOwner(), "Actor Animating")) then
      dohalt = true
   end

   if (trace.Entity:IsValid() && trace.Entity:GetClass() == "cycler_actor" && !dohalt) then
       if (NPCProtectCheck( self:GetOwner(), trace.Entity )) then
          local sequence = self:GetClientInfo("currentanim")
          local grp = self:GetClientInfo("currentgrp")
          if (sequence != "") then
             animateNpc( self:GetOwner(), grp, sequence, trace.Entity )
          else
             self:GetOwner():PrintMessage(HUD_PRINTTALK, "You don't have a sequence set to animate!")
          end
       end
     end
   end
   if (!dohalt) then
      return true
   else
      return false
   end
end

function TOOL:RightClick( trace )
   if SERVER then
     local dohalt = false
     if (GetConVarNumber("npc_allow_actors") != 1 && !SinglePlayer()) then
        self:GetOwner():PrintMessage(HUD_PRINTTALK, "Actor Animating is not allowed on this server")
        dohalt = true
     end
     if (!AdminCheck(self:GetOwner(), "Actor Animating")) then
        dohalt = true
     end
  
     if (trace.Entity:IsValid() && trace.Entity:GetClass() == "cycler_actor" && !dohalt) then
         if (NPCProtectCheck( self:GetOwner(), trace.Entity )) then
            if SERVER then
               local sequence = self:GetClientInfo("currentanim")
               local grp = self:GetClientInfo("currentgrp")
               AddQueue( self:GetOwner(), trace.Entity, sequence, grp, self:GetClientNumber("newqueuekey") )
            end
         end
     end
  end
  return true
end

function TOOL:Reload( trace )
   if SERVER then
     local dohalt = false
     if (GetConVarNumber("npc_allow_actors") != 1 && !SinglePlayer()) then
        self:GetOwner():PrintMessage(HUD_PRINTTALK, "Actor Animating is not allowed on this server")
        dohalt = true
     end
     if (!AdminCheck(self:GetOwner(), "Actor Animating")) then
        dohalt = true
     end

     if (trace.Entity:IsValid() && trace.Entity:GetClass() == "cycler_actor") then
      if (!dohalt && NPCProtectCheck( self:GetOwner(), trace.Entity )) then
        if (existingseqs[self:GetOwner()] == nil) then existingseqs[self:GetOwner()] = {} end
        if (existingseqs[self:GetOwner()][trace.Entity] != nil) then
          existingseqs[self:GetOwner()][trace.Entity]:SetName("")
          existingseqs[self:GetOwner()][trace.Entity]:Fire("Kill", "", 0)
          existingseqs[self:GetOwner()][trace.Entity] = nil
        end
        if (queuednpcs[self:GetOwner()] != nil && queuednpcs[self:GetOwner()][trace.Entity] != nil) then
           numpad.Remove(queuednpcs[self:GetOwner()][trace.Entity].numindex)
           queuednpcs[self:GetOwner()][trace.Entity] = nil
        end
      end
     end
  end
  return true
end

function TOOL.BuildCPanel( panel )
   panel:AddControl("Label", {Text = "To select an animation, you must open the animations window, which contains the animations in a list!"})
   panel:AddControl("Button", {Label = "Open Window", Command = "npc_showanimwindow"})
   panel:AddControl("Numpad", {Label = "Queue Key", Command = "npc_actor_anims_newqueuekey", ButtonSize = 13})
   panel:AddControl("Label", {Text = "If you wish to create a bind to open the window, bind a key to \"npc_showanimwindow\""})
   panel:AddControl("Label", {Text = "When non-looping animations end, the actor goes into a reference pose, simply Reload to fix him"})
end