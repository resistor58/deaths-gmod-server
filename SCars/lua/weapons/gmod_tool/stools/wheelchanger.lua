
TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Wheel changer"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
	model    = "models/Splayn/cadillac_wh.mdl",
	physmaterial = "rubber"
}

if CLIENT then

	language.Add( "Tool_wheelchanger_name", "Wheel changer" )	
	language.Add( "Tool_wheelchanger_desc", "Change the wheels on the cars" )		
	language.Add( "Tool_wheelchanger_0", "Primary fire: Change wheel" )	

end
function TOOL:LeftClick( trace )



	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()


	local model	  = self:GetClientInfo( "model" )
	local physMat = self:GetClientInfo( "physmaterial" ) 
	
	if trace.Entity:IsValid() then
		trace.Entity:ChangeWheel( model, physMat )
		trace.Entity.WheelModel = model	
		trace.Entity.physMat = physMat
		trace.Entity:EmitSound("carStools/wheel.wav",80,math.random(100,150))
	end
	return true

end

function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	local physMat = trace.Entity.physMat 
	self:GetOwner():ConCommand("wheelchanger_physmaterial "..physMat)	
	
	local model   = trace.Entity.WheelModel
	self:GetOwner():ConCommand("wheelchanger_model "..model)

	return true
end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "Carframes", Description	= "Spawn carframes" }  )			
		
--[[		
ThaMaterialBox = {}
ThaMaterialBox.Label = "Cars"
ThaMaterialBox.MenuButton = 0
ThaMaterialBox.Height = 100
ThaMaterialBox.Width = 100
ThaMaterialBox.Rows = 2
ThaMaterialBox.Options = {}
ThaMaterialBox.Options["Belair"] = { Material = "vgui/wheel_belair", wheelchanger_select = 1, wheelchanger_model = "models/Splayn/belair_wheel.mdl", Value = "Belair" }
ThaMaterialBox.Options["Cadillac"] = { Material = "vgui/wheel_cadillac", wheelchanger_select = 2, wheelchanger_model = "models/Splayn/cadillac_wh.mdl", Value = "Cadillac" }
ThaMaterialBox.Options["Camaro"] = { Material = "vgui/wheel_camaro", wheelchanger_select = 3, wheelchanger_model = "models/Splayn/camaro_wheel.mdl", Value = "Camaro" }
ThaMaterialBox.Options["Chevy 66"] = { Material = "vgui/wheel_chevy66", wheelchanger_select = 4, wheelchanger_model = "models/Splayn/chevy66_wheel.mdl", Value = "Chevy 66" }
ThaMaterialBox.Options["Ford GT"] = { Material = "vgui/wheel_fordGT", wheelchanger_select = 5, wheelchanger_model = "models/Splayn/fordgt_wh.mdl", Value = "Ford GT" }
ThaMaterialBox.Options["Hummer"] = { Material = "vgui/wheel_hummer", wheelchanger_select = 6, wheelchanger_model = "models/Splayn/hummerwh_h2.mdl", Value = "Hummer" }
ThaMaterialBox.Options["Mustang Fastback"] = { Material = "vgui/wheel_mustang", wheelchanger_select = 7, wheelchanger_model = "models/Splayn/mustang_wheel.mdl", Value = "Mustang Fastback" }
ThaMaterialBox.Options["Studebaker"] = { Material = "vgui/wheel_studebaker", wheelchanger_select = 8, wheelchanger_model = "models/Splayn/studebaker_wh.mdl", Value = "Studebaker" }
ThaMaterialBox.Options["Junker"] = { Material = "vgui/wheel_junker", wheelchanger_select = 9, wheelchanger_model = "models/props_vehicles/carparts_wheel01a.mdl", Value = "Junker" }
ThaMaterialBox.Options["Impala88"] = { Material = "vgui/wheel_impala88", wheelchanger_select = 10, wheelchanger_model = "models/Splayn/impala88_wheel.mdl", Value = "Impala88" }
ThaMaterialBox.Options["Banshee"] = { Material = "vgui/wheel_Banshee", wheelchanger_select = 11, wheelchanger_model = "models/dean/gtaiv/vehicles/bansheewheel.mdl", Value = "Banshee" }

--ThaMaterialBox.Options["Sabre"] = { Material = "vgui/entities/sent_Sakarias_Weapon_Turret", wheelchanger_select = 12, wheelchanger_model = "models/sabregt_wheel.mdl", Value = "Sabre" }
ThaMaterialBox.Options["Huntley"] = { Material = "vgui/wheel_huntley", wheelchanger_select = 13, wheelchanger_model = "models/huntleyw.mdl", Value = "Huntley" }
--ThaMaterialBox.Options["Emperor"] = { Material = "vgui/entities/sent_Sakarias_Weapon_Turret", wheelchanger_select = 14, wheelchanger_model = "models/emperor_wheel.mdl", Value = "Emperor" }
ThaMaterialBox.Options["Bobcat"] = { Material = "vgui/wheel_bobcat", wheelchanger_select = 15, wheelchanger_model = "models/bobcatw.mdl", Value = "Bobcat" }
--ThaMaterialBox.Options["Comet"] = { Material = "vgui/entities/sent_Sakarias_Weapon_Turret", wheelchanger_select = 16, wheelchanger_model = "models/dean/gtaiv/vehicles/cometwheel.mdl", Value = "Comet" }
--ThaMaterialBox.Options["Lokus"] = { Material = "vgui/entities/sent_Sakarias_Weapon_Turret", wheelchanger_select = 17, wheelchanger_model = "models/dean/gtaiv/vehicles/lokus_wheel.mdl", Value = "Lokus" }
ThaMaterialBox.Options["Ratmobile"] = { Material = "vgui/wheel_Ratmobile", wheelchanger_select = 12, wheelchanger_model = "models/DIPRIP/Ratmobile/Ratmobile_wheel.mdl", Value = "Ratmobile" }
ThaMaterialBox.Options["Chaos126p"] = { Material = "vgui/wheel_Chaos126p", wheelchanger_select = 13, wheelchanger_model = "models/DIPRIP/Chaos126p/Chaos126p_wheel.mdl", Value = "Chaos126p" }
ThaMaterialBox.Options["Hedgehog"] = { Material = "vgui/wheel_Hedgehog", wheelchanger_select = 14, wheelchanger_model = "models/DIPRIP/Hedgehog/Hedgehog_wheel.mdl", Value = "Hedgehog" }




CPanel:AddControl("MaterialGallery", ThaMaterialBox)
--]]

	ThaMaterialBox = {}
	ThaMaterialBox.Label = "Wheels"
	ThaMaterialBox.MenuButton = 0
	ThaMaterialBox.Height = 100
	ThaMaterialBox.Width = 100
	ThaMaterialBox.Rows = 2
	ThaMaterialBox.Options = list.Get( "scar_wheels" )
	--ThaMaterialBox.Options = {}

	
	--local nrOfWheels, wheelName, wheelIcon, wheelModel = SakariasSCar_GetAllWheelInfo()
	
	
	--for i=1,nrOfWheels do 
		--ThaMaterialBox.Options[wheelName[i]] = { Material = wheelIcon[i], carspawner_model = wheelModel[i] , Value = wheelName[i] }
	--end

	CPanel:AddControl("MaterialGallery", ThaMaterialBox)

	CPanel:AddControl( "Label", { Text = "Wheel physical properties", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#Tool_Car_Sounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "physMaterials" ) } )	

end

list.Set( "physMaterials", "#Rubber", { wheelchanger_physmaterial = "rubber" } )
list.Set( "physMaterials", "#Rubber tire", { wheelchanger_physmaterial = "rubbertire" } )
list.Set( "physMaterials", "#Sliding rubber tire", { wheelchanger_physmaterial = "slidingrubbertire" } )
list.Set( "physMaterials", "#Jeep tire", { wheelchanger_physmaterial = "jeeptire" } )
list.Set( "physMaterials", "#Braking rubber tire", { wheelchanger_physmaterial = "brakingrubbertire" } )
