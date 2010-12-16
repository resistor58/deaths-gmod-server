
TOOL.Category		= "Spawnables"
TOOL.Name			= "#RadioMod"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab        = "RadioMod"

cleanup.Register( "Electronics" )

TOOL.ClientConVar = {
	model    = "models/Items/car_battery01.mdl",
	select   = "1",
}

if CLIENT then
	
	language.Add( "Tool_easyengineelectronics_name", "Electronics" )
	language.Add( "Tool_easyengineelectronics_desc", "Spawn electronics" )
	language.Add( "Tool_easyengineelectronics_0", "Primary fire: spawn" )
	language.Add( "Undone_Electronics", "Undone Electronics" )
	language.Add( "Cleanup_Electronics", "Engine Mod: Electronics" )
	language.Add( "Cleaned_Electronics", "Electronics Removed" )
	
--	CreateConVar('EN_ElectronicModel', "blah")		
--	CreateConVar('electronicschoosen', 1)
end
function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local electronicsNum			= 	self:GetClientNumber( "select" )

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local electronicsProp = Makeelectronics( Ang, trace.HitPos, electronicsNum, ply )


	local min = electronicsProp:OBBMins()
	electronicsProp:SetPos( trace.HitPos - trace.HitNormal * min.z )	

	
	undo.Create("Electronics")
		undo.AddEntity( electronicsProp )
		undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "Electronics", electronicsProp )
	
	return true

end


if (SERVER) then

	function Makeelectronics( Ang, Pos, Num, ply )
	
local electronics = null
	
		if Num == 1 or Num == 2 or Num == 3 then
		if Num == 1 then
		electronics = ents.Create( "prop_physics" )
		electronics:SetModel("models/Items/car_battery01.mdl")
		electronics:SetPos( Pos ) 
		electronics:SetAngles( Ang )
		electronics:Spawn()
		electronics:Activate() 
		end

		if Num == 2 then
		electronics = ents.Create( "prop_physics" )
		electronics:SetModel("models/props_junk/garbage_metalcan002a.mdl")
		electronics:SetPos( Pos ) 
		electronics:SetAngles( Ang )
		electronics:Spawn()
		electronics:Activate() 
		end

		if Num == 3 then
		electronics = ents.Create( "prop_physics" )
		electronics:SetModel("models/props_lab/reciever01b.mdl")
		electronics:SetPos( Pos ) 
		electronics:SetAngles( Ang )
		electronics:Spawn()
		electronics:Activate() 
		end		

			else
		
		if Num == 4 then
		electronics = ents.Create( "sent_FrontLight" )
		end

		if Num == 5 then
		electronics = ents.Create( "sent_L_DirIndicator" )
		electronics.Owner = ply
		end		
		
		if Num == 6 then
		electronics = ents.Create( "sent_R_DirIndicator" )
		electronics.Owner = ply	
		end

		if Num == 7 then
		electronics = ents.Create( "sent_RearLight" )
		electronics.Owner = ply	
		end

		if Num == 8 then
		electronics = ents.Create( "sent_guage" )
		end

		if Num == 9 then
		electronics = ents.Create( "sent_thermo" )
		end

		if Num == 10 then
		electronics = ents.Create( "sent_Radio2" )
		end

		if Num == 11 then
		electronics = ents.Create( "sent_Radio3" )
		end
		
		electronics:SetAngles( Ang )
		electronics:SetPos( Pos )
		electronics:Spawn()
		
		end

					
		return electronics
		
	end

end

function TOOL:UpdateGhostElectronics( ent, player )

	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit) then return end	
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local min = ent:OBBMins()
	 ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( Ang )
	
	ent:SetNoDraw( false )

end

function TOOL:Think()

	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
	self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostElectronics( self.GhostEntity, self:GetOwner() )
	
end

function TOOL.BuildCPanel( CPanel )


	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_easyengineelectronics_name", Description	= "Spawn electronics" }  )
															 	

ThaMaterialBox = {}
ThaMaterialBox.Label = "Fuel"
ThaMaterialBox.MenuButton = 0
ThaMaterialBox.Height = 100
ThaMaterialBox.Width = 100
ThaMaterialBox.Rows = 2
ThaMaterialBox.Options = {}
ThaMaterialBox.Options["Radio3"] = { Material = "vgui/entities/sent_Radio3", radiomodelectronics_select = 11, radiomodelectronics_model = "models/props_lab/citizenradio.mdl", Value = "Radio electro" }

CPanel:AddControl("MaterialGallery", ThaMaterialBox)

								 
end
