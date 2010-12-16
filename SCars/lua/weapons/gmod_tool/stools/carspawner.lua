TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""

cleanup.Register( "Cars" )

TOOL.ClientConVar = {
	model    = "sent_Sakarias_Car_chevy66",
	select   = "1",
}

if CLIENT then

	language.Add( "Tool_carspawner_name", "Car spawner" )	
	language.Add( "Tool_carspawner_desc", "Spawn Cars" )		
	language.Add( "Tool_carspawner_0", "Primary fire: spawn" )
	language.Add( "Undone_Cars", "Undone Car" )
	language.Add( "Cleanup_Cars", "Sakarias88 Cars" )
	language.Add( "Cleaned_Cars", "Cars Removed" )		


end
function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	local MaxCarsAllowed  = GetConVarNumber( "scar_maxscars" )
	local nrOfCars = ply:GetCount( "SCar" )   
	   
	if nrOfCars >= MaxCarsAllowed - 1 then 	
		ply:PrintMessage( HUD_PRINTTALK, "You have reached SCar spawn limit")
		return false 
	end
	   
	local CarNum = self:GetClientNumber( "select" )
	local model = self:GetClientInfo( "model" )
	
	local addHeight = SakariasSCar_GetSpawnHeight( model )
	
	
	
	
	local CarEnt = ents.Create( model )
	
	if ValidEntity(CarEnt) then
		CarEnt:Spawn()
		
		CarEnt:SetPos( trace.HitPos + Vector(0,0, addHeight))	
		CarEnt:SetCarOwner( ply )

		local Ang = trace.HitNormal:Angle()
		Ang.pitch = Ang.pitch + 90
		local plyAng = ply:GetAimVector():Angle()
		Ang.y = plyAng.y
		
		CarEnt:SetAngles( Ang )	
		CarEnt:Reposition( ply )
		CarEnt.handBreakDel = CurTime() + 2
		CarEnt.spawnedBy = ply	
		CarEnt:UpdateAllCharacteristics()
		
		ply:AddCount( "SCar", CarEnt )	
			
		undo.Create("Cars")
		undo.AddEntity( CarEnt )
		undo.SetPlayer( ply )
		undo.Finish()
			
		ply:AddCleanup( "Cars", CarEnt )
		
		return true
	end
	
	return false
end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_carspawner_name", Description	= "#Tool_carspawner_desc" }  )									 
			

	ThaMaterialBox = {}
	ThaMaterialBox.Label = "Cars"
	ThaMaterialBox.MenuButton = 0
	ThaMaterialBox.Height = 100
	ThaMaterialBox.Width = 100
	ThaMaterialBox.Rows = 2
	ThaMaterialBox.Options = {}


	local nrOfScars = SakariasSCar_GetNrOfScars()
	
	local allScarNames = {}
	local allScarEntNames = {}
	allScarNames = SakariasSCar_GetScarNames()
	allScarEntNames =  SakariasSCar_GetScarEntNames()

	for i=1,nrOfScars do 
		ThaMaterialBox.Options[allScarNames[i]] = { Material = "vgui/entities/"..allScarEntNames[i], carspawner_select = i, carspawner_model = allScarEntNames[i] , Value = allScarNames[i] }
	end


	CPanel:AddControl("MaterialGallery", ThaMaterialBox)

end