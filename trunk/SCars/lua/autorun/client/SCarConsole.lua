
--Thanks Overv! You are awesome.
--Overv helped me with everything in this menu.
--All credits to Overv.

AddCSLuaFile( "SCarConsole.lua" )

local limits = { "scar_acceleration", "scar_maxspeed", "scar_turborffect", "scar_turboduration", "scar_turbodelay", "scar_reverseforce", "scar_reversemaxspeed", 
"scar_breakEfficiency", "scar_steerforce", "scar_steerresponse", "scar_stabilisation", "scar_nrofgears", "scar_usert", "scar_usehud", "scar_thirdpersonview", 
"scar_fuelconsumptionuse","scar_allowHydraulics","scar_tiredamage","scar_cardamage", "scar_useweaponammo", "scar_fuelconsumption", "scar_maxhealth", "scar_maxantislide", "scar_maxautostraighten","scar_maxscars", "scar_removedelay" }
local sliders = {}

local sliderName = { "Max Power", "Max Speed", "Max Turbo Effect", "Max Turbo Duration", "Min Turbo Delay", "Max Reverse Power", "Max Reverse Speed", 
"Max Break Efficiency", "Max Steer Force", "Max Steer Response", "Max Stabilisation", "Min Number of Gears", "Allow RT", "Allow Hud", "Allow Third Person View", 
"Allow disabling Fuel Consumption","Allow Hydraulics","Allow disabling tire damage","Allow disabling car damage", "Infinite Ammo" , "Min Fuel Consumption", "Max Health", "Max Anti Slide", "Auto Straighten", "SCar spawn limit", "Remove after exploded (in seconds)"  }

local sliderMin = {     0,   10, 1,  1,  1,    0,    0, 0.5,  0, 0,    0,  1, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 100, 0, 0, 0, 0}
local sliderMax = { 10000, 5000, 5, 10, 60, 5000, 1000,   4, 20, 2, 3000, 10, 1, 1, 1, 1, 1, 1, 1, 1,  20, 1000, 200, 200, 20, 120}

local function ApplySettings()

	for _, v in pairs( sliders ) do
		if (v.SCarConVar != nil && v.SCarConVar != NULL && GetConVar( v.SCarConVar ) != nil && GetConVar( v.SCarConVar ) != NULL ) then

			local val =  v:GetValue()
			
			if _ >= 13 && _ <= 20 then
				val = 0
			
				if v:GetChecked( true ) then
					val = 1
				end
			
				--Have to run it on client or the checkboxes won't remeber the values.
				RunConsoleCommand( v.SCarConVar, val)				
			end
			
			RunConsoleCommand( "sakarias_changelimit", v.SCarConVar, val )	

		end
	end

	RunConsoleCommand( "sakarias_updateallvehicles" )

end


concommand.Add("scar_showmenu", function()
	
	ply = LocalPlayer()
	
	if ply:IsAdmin() then
		
		local labelColor = Color(200,255,255)
		local offset = 18
		
		local dermaPanel = vgui.Create( "DFrame" ) 
		dermaPanel:SetPos( 50,50 ) 
		dermaPanel:SetSize( 380, 545 ) 
		dermaPanel:SetTitle( "SCar limitations" ) 
		dermaPanel:SetVisible( true ) 
		dermaPanel:SetDraggable( true ) 
		dermaPanel:ShowCloseButton( true ) 
		dermaPanel:MakePopup()

		local offsetList = vgui.Create( "DPanelList", dermaPanel )
		offsetList:SetPos( 25, 25+offset )
		offsetList:SetSize( 345, 480 )		
		offsetList:SetSpacing( 2 )
		offsetList:SetPadding( 10 )
		offsetList:EnableHorizontal( false )
		offsetList:EnableVerticalScrollbar( false )			
		

		for _, limit in pairs( limits ) do

			local valid = false
			
			if _ < 13 or _ > 20  then 
				local slider = vgui.Create( "DNumSlider", dermaPanel )
				slider:SetText( sliderName[_] )
				slider:SetSize( 150, 50 )
				slider:SetMin( sliderMin[_] )			
				slider:SetMax( sliderMax[_] )
				slider:SetDecimals( 1 )					
				slider.SCarConVar = limit
				slider:SetConVar( limit )			
				
				offsetList:AddItem(slider)
				sliders[_] = slider
				
			end
						
		end
			

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[13] ) 
		checkBox:SetValue( GetConVarNumber( limits[13] ) )
		checkBox.SCarConVar = limits[13]
		offsetList:AddItem(checkBox)
		sliders[13] = checkBox

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[14] ) 
		checkBox:SetValue( GetConVarNumber( limits[14] ) )
		checkBox.SCarConVar = limits[14]
		offsetList:AddItem(checkBox)
		sliders[14] = checkBox

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[15] ) 
		checkBox:SetValue( GetConVarNumber( limits[15] ) )
		checkBox.SCarConVar = limits[15]
		offsetList:AddItem(checkBox)
		sliders[15] = checkBox

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[16] ) 
		checkBox:SetValue( GetConVarNumber( limits[16] ) )
		checkBox.SCarConVar = limits[16]
		offsetList:AddItem(checkBox)
		sliders[16] = checkBox		

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[17] ) 
		checkBox:SetValue( GetConVarNumber( limits[17] ) )
		checkBox.SCarConVar = limits[17]
		--checkBox:SetConVar( limits[17] )
		offsetList:AddItem(checkBox)
		sliders[17] = checkBox	

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[18] ) 
		checkBox:SetValue( GetConVarNumber( limits[18] ) )
		checkBox.SCarConVar = limits[18]
		offsetList:AddItem(checkBox)
		sliders[18] = checkBox	
		
		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[19] ) 
		checkBox:SetValue( GetConVarNumber( limits[19] ) )
		checkBox.SCarConVar = limits[19]
		--checkBox:SetConVar( limits[19] )
		offsetList:AddItem(checkBox)
		sliders[19] = checkBox			

		local checkBox = vgui.Create( "DCheckBoxLabel", dermaPanel ) 
		checkBox:SetPos( 25,550 ) 
		checkBox:SetSize( 150, 20 )
		checkBox:SetText( sliderName[20] ) 
		checkBox:SetValue( GetConVarNumber( limits[20] ) )
		checkBox.SCarConVar = limits[20]
		offsetList:AddItem(checkBox)
		sliders[20] = checkBox	
		
--		13 14 15 16 17 18 19 20
		
		offsetList.Think = function()
			if ( input.IsMouseDown( MOUSE_LEFT ) ) then
				offsetList.applySettings = true
			elseif ( !input.IsMouseDown( MOUSE_LEFT ) and offsetList.applySettings ) then
				ApplySettings()
				offsetList.applySettings = false
			end
		end
		
			
		
	end
	
end)

	