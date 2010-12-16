include("shared_cl.lua")

if CLIENT then
  menuitems = {}
  menuitems2 = {}
  function npc_showWindow( ply, cmd, arg )
    local currentanim = GetConVarString("npc_actor_anims_currentanim")
    //local currentgrp = GetConVarNumber("npc_actor_anims_grpno")
    animwindow = vgui.Create("DFrame")
    animwindow:SetPos( 50, 50 )
    animwindow:SetSize( 390, 240 )
    animwindow:SetTitle( "NPC Animations" )
    animwindow:SetVisible( true )
    animwindow:MakePopup()

    animwindow_label1 = vgui.Create("DLabel")
    animwindow_label1:SetPos( 10, 25 )
    animwindow_label1:SetText( "Select an animation, close the window, and click on an actor!" )
    animwindow_label1:SetParent( animwindow )
    animwindow_label1:SetSize( 370, 20 )
    
    animwindow_label2 = vgui.Create("DLabel")
    animwindow_label2:SetPos( 10, 170 )
    animwindow_label2:SetSize( 370, 40 )
    animwindow_label2:SetParent( animwindow )
    animwindow_label2:SetText( "Double click a group to see it's animations.\nDouble click an animation to select it." )
    
    animwindow_label3 = vgui.Create("DLabel")
    animwindow_label3:SetPos( 10, 205 )
    animwindow_label3:SetSize( 370, 20 )
    animwindow_label3:SetParent( animwindow )
    animwindow_label3:SetText("Current Animation: " .. currentanim)

    animwindow_combo1 = vgui.Create("DListView")
    animwindow_combo1:AddColumn( "Animation Groups" )
    animwindow_combo1:SetPos( 10, 50 )
    animwindow_combo1:SetSize( 175, 120 )
    animwindow_combo1:SetParent( animwindow )
    animwindow_combo1.DoDoubleClick = function()
       animwindow_combo2:Clear()
       local s = menuitems[animwindow_combo1:GetSelectedLine()]
       local x = 1
       for k, v in pairs(ActorAnims[s]) do
           animwindow_combo2:AddLine(k)
           menuitems2[x] = k
           x = x + 1
       end
    end
    local i = 1
    for k, v in pairs(ActorAnims) do
       animwindow_combo1:AddLine(k)
       menuitems[i] = k
       i = i + 1
    end
    
    animwindow_combo2 = vgui.Create("DListView")
    animwindow_combo2:AddColumn( "Animations" )
    animwindow_combo2:SetPos( 205, 50 )
    animwindow_combo2:SetSize( 175, 120 )
    animwindow_combo2:SetParent( animwindow )
    animwindow_combo2.DoDoubleClick = function()
       local val = animwindow_combo2:GetSelectedLine()
       local val2 = animwindow_combo1:GetSelectedLine()
       ply:ConCommand("npc_actor_anims_currentanim \"" .. menuitems2[val] .. "\"")
       ply:ConCommand("npc_actor_anims_currentgrp \"" .. menuitems[val2] .. "\"")
       animwindow_label3:SetText("Current Animation: " .. menuitems2[val])
    end
  end
  concommand.Add("npc_showanimwindow", npc_showWindow)
end
