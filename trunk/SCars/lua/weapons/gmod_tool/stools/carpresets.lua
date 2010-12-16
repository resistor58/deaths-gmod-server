
TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Presets"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
	CarHealth    = "200",
	CanTakeDamage = "1",
	CanTakeWheelDamage = "1",
	SuspensionAddHeight    = "0",
	Active = "0",
	SoftnesFront = "0",
	SoftnesRear = "0",
	liveAction = "0",
	liveAction2 = "0",	
	HeightFront = "0",
	HeightRear = "0",
	Skin = "0",
	model    = "models/props_vehicles/carparts_wheel01a.mdl",
	select   = "1",
	physmaterial = "rubber",	
	FuelConsumptionUse = "0",
	FuelConsumption = "100",
	BreakEfficiency    = "10",
	ReverseForce   = "1000",
	ReverseMaxSpeed = "200",
	TurboEffect = "2",
	TurboDuration = "5",
	TurboDelay = "5",
	Acceleration = "3000",
	SteerForce = "5",
	MaxSpeed = "1500",
	NrOfGears = "5",
	soundname = "vehicles/Airboat/fan_motor_idle_loop1.wav",
	useRT = "0",
	UseHUD = "1",
	SteerResponse = "0.3",
	Stabilisation = "0",
	ThirdPersonView = "0",
	CameraCorrection = "0",
	AntiSlide = "0",	
}


if CLIENT then

	language.Add( "Tool_carpresets_name", "Presets" )
	language.Add( "Tool_carpresets_desc", "Can tune cars with it" )
	language.Add( "Tool_carpresets_0", "Primary fire to paste and secondary fire to copy" )
	
end

function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	--Getting all the values
	local CarHealth = self:GetClientNumber( "CarHealth" )
	local CanTakeDamage = self:GetClientNumber( "CanTakeDamage" )	
	local CanTakeWheelDamage = self:GetClientNumber( "CanTakeWheelDamage" )
	local SuspensionAddHeight = self:GetClientNumber( "SuspensionAddHeight" )
	local newSuspensionAddHeight = SuspensionAddHeight * -1	
	local Active = self:GetClientNumber( "Active" )			
	local SoftnesFront			= self:GetClientNumber( "SoftnesFront" )
	local SoftnesRear			= self:GetClientNumber( "SoftnesRear" )
	local HeightFront           = self:GetClientNumber( "HeightFront" )
	local HeightRear            = self:GetClientNumber( "HeightRear" )	
	local NewHeightFront = HeightFront * -1
	local NewHeightRear  = HeightRear * -1	
	local model			= self:GetClientInfo( "model" )
	local physMat = self:GetClientInfo( "physmaterial" ) 	
	local FuelConsumptionUse = self:GetClientNumber( "FuelConsumptionUse" )
	local FuelConsumption = self:GetClientNumber( "FuelConsumption" )
	local Skin = self:GetClientNumber( "Skin" )
	local BreakEfficiency   = self:GetClientNumber( "BreakEfficiency" )
	local ReverseForce   = self:GetClientNumber( "ReverseForce" )
	local ReverseMaxSpeed = self:GetClientNumber( "ReverseMaxSpeed" )
	local TurboEffect = self:GetClientNumber( "TurboEffect" )
	local TurboDuration = self:GetClientNumber( "TurboDuration" )
	local TurboDelay = self:GetClientNumber( "TurboDelay" )
	local Acceleration = self:GetClientNumber( "Acceleration" )
	local SteerForce = self:GetClientNumber( "SteerForce" )
	local MaxSpeed = self:GetClientNumber( "MaxSpeed" )
	local NrOfGears = self:GetClientNumber( "NrOfGears" ) 
	local EngineSound = self:GetClientInfo( "soundname" )
	local useRT = self:GetClientNumber( "useRT" )
	local UseHUD = self:GetClientNumber( "UseHUD" )
	local SteerResponse = self:GetClientNumber( "SteerResponse" )
	local Stabilisation =  self:GetClientNumber( "Stabilisation" )
	local ThirdPersonView =  self:GetClientNumber( "ThirdPersonView" )
	local CameraCorrection = self:GetClientNumber( "CameraCorrection" )
	local AntiSlide = self:GetClientNumber( "AntiSlide" )
	
	--Getting all the limits
	local allowDisablingWheelDamage =  GetConVarNumber("scar_tiredamage") 
	local allowDisablingCarDamage =  GetConVarNumber("scar_cardamage") 
	local maxHealthAllowed = GetConVarNumber("scar_maxhealth") 	
	local allowHydraulics = GetConVarNumber("scar_allowHydraulics") 	
	local AllowDisablingFuelConsumption = GetConVarNumber("scar_fuelconsumptionuse")
	local MinFuelConsumption = GetConVarNumber("scar_fuelconsumption")	
	local LimitMaxBreakEfficiency   = GetConVarNumber( "scar_breakefficiency" )--Max Break Efficiency
	local LimitMaxReverseForce   = GetConVarNumber( "scar_reverseforce" )--Max Reverse Force
	local LimitMaxReverseSpeed = GetConVarNumber( "scar_reversemaxspeed" )--Max Reverse Speed
	local LimitMaxTurboEffect = GetConVarNumber( "scar_turborffect" )--Max Turbo Effect
	local LimitMaxTurboDuration = GetConVarNumber( "scar_turboduration" )--Max Turbo Duration
	local LimitMinTurboDelay = GetConVarNumber( "scar_turbodelay" )--Min Turbo Delay
	local LimitMaxAcceleration = GetConVarNumber( "scar_acceleration" )--Max Acceleration
	local LimitMaxSteerForce = GetConVarNumber( "scar_steerforce" )--Max Steer Force
	local LimitMaxSpeed = GetConVarNumber( "scar_maxspeed" )--Max Speed
	local LimitMinNumberofGears = GetConVarNumber( "scar_nrofgears" )--Min Number of Gears
	local LimitAllowRT = GetConVarNumber( "scar_usert" )--Allow RT
	local LimitAllowHud = GetConVarNumber( "scar_usehud" )--Allow Hud
	local LimitMaxSteerResponse = GetConVarNumber( "scar_steerresponse" )--Max Steer Response
	local LimitMaxStabilisation =  GetConVarNumber( "scar_stabilisation" )--Max Stabilisation
	local LimitAllowThirdPersonView =  GetConVarNumber( "scar_thirdpersonview" )--Allow Third Person View
	local LimitMaxAntiSlide = GetConVarNumber("scar_maxantislide")--Max Anti Slide
	local maxAcc = GetConVarNumber("SCar_Acceleration")	
	
	--Checking all the limits
	if maxHealthAllowed < CarHealth then
		CarHealth = maxHealthAllowed
	end	

	if CanTakeDamage == 0 && allowDisablingCarDamage == 0 then
		CanTakeDamage = 1
	end

	if CanTakeWheelDamage == 0 && allowDisablingWheelDamage == 0 then
		CanTakeWheelDamage = 1
	end
	
	if allowHydraulics == 0 then
		Active = 0
	end	
	
	if FuelConsumption < MinFuelConsumption then
		FuelConsumption = MinFuelConsumption
	end

	if AllowDisablingFuelConsumption == 0 && FuelConsumptionUse == 0 then
		FuelConsumptionUse = 1
	end
	
	if MinFuelConsumption > FuelConsumption then
		FuelConsumption = MinFuelConsumption
	end	

	if BreakEfficiency > LimitMaxBreakEfficiency then
		BreakEfficiency = LimitMaxBreakEfficiency
		--ply:PrintMessage( HUD_PRINTTALK, "BREAK EFFICIENCY limit: "..LimitMaxBreakEfficiency)
	end
	
	if ReverseForce > LimitMaxReverseForce then
		ReverseForce = LimitMaxReverseForce
		--ply:PrintMessage( HUD_PRINTTALK, "REVERSE FORCE limit: "..LimitMaxReverseForce)
	end
	
	if ReverseMaxSpeed > LimitMaxReverseSpeed then
		ReverseMaxSpeed = LimitMaxReverseSpeed
		--ply:PrintMessage( HUD_PRINTTALK, "REVERSE MAX SPEED limit: "..LimitMaxReverseSpeed)
	end
	
	if TurboEffect > LimitMaxTurboEffect then 
		TurboEffect = LimitMaxTurboEffect
		--ply:PrintMessage( HUD_PRINTTALK, "TURBO EFFECT limit: "..LimitMaxTurboEffect)
	end
	
	if TurboDuration > LimitMaxTurboDuration then
		TurboDuration = LimitMaxTurboDuration
		--ply:PrintMessage( HUD_PRINTTALK, "TURBO DURATION limit: "..LimitMaxTurboDuration)
	end
	
	if TurboDelay < LimitMinTurboDelay then
		TurboDelay = LimitMinTurboDelay
		--ply:PrintMessage( HUD_PRINTTALK, "MIN TURBO DELAY limit: "..LimitMinTurboDelay)			
	end
	
	if Acceleration > LimitMaxAcceleration then
		Acceleration = LimitMaxAcceleration
		--ply:PrintMessage( HUD_PRINTTALK, "ACCELERATION limit: "..LimitMaxAcceleration)				
	end
	
	if SteerForce > LimitMaxSteerForce then
		SteerForce = LimitMaxSteerForce
		--ply:PrintMessage( HUD_PRINTTALK, "STEER FORCE limit: "..LimitMaxSteerForce)				
	end
	
	if MaxSpeed > LimitMaxSpeed then
		MaxSpeed = LimitMaxSpeed
		--ply:PrintMessage( HUD_PRINTTALK, "MAX SPEED limit: "..LimitMaxSpeed)				
	end
	
	if NrOfGears < LimitMinNumberofGears then
		NrOfGears = LimitMinNumberofGears
		--ply:PrintMessage( HUD_PRINTTALK, "MIN GEARS limit: "..LimitMinNumberofGears)				
	end
	
	if useRT == 1 && LimitAllowRT == 0 then
		useRT = 0
		--ply:PrintMessage( HUD_PRINTTALK, "RT Lamps not allowed!")				
	end
	
	if UseHUD == 1 && LimitAllowHud == 0 then
		UseHUD = 0
		--ply:PrintMessage( HUD_PRINTTALK, "SCar HUD not allowed!")				
	end
	
	if SteerResponse > LimitMaxSteerResponse then
		SteerResponse = LimitMaxSteerResponse
		--ply:PrintMessage( HUD_PRINTTALK, "STEER RESPONSE limit: "..LimitMaxSteerResponse)				
	end
	
	if Stabilisation > LimitMaxStabilisation then
		Stabilisation = LimitMaxStabilisation
		--ply:PrintMessage( HUD_PRINTTALK, "STABILISATION limit: "..LimitMaxStabilisation)				
	end
	
	if ThirdPersonView == 1 && LimitAllowThirdPersonView == 0 then
		ThirdPersonView = 0
		--ply:PrintMessage( HUD_PRINTTALK, "Third Person View not allowed!")				
	end		

	if AntiSlide > LimitMaxAntiSlide then
		AntiSlide = LimitMaxAntiSlide
	end
	
	if Acceleration > maxAcc then 
		Acceleration = maxAcc 
	end	
	
	if trace.Entity:IsValid()  then


		--Applying all the values
		trace.Entity:SetCarHealth( CarHealth )
		trace.Entity.CarHealth = CarHealth
		trace.Entity:SetCanTakeDamage( CanTakeDamage, CanTakeWheelDamage )
		trace.Entity.CanTakeDamage = CanTakeDamage
		trace.Entity.CanTakeWheelDamage = CanTakeWheelDamage
		trace.Entity:SetSuspensionAddHeight( newSuspensionAddHeight )
		trace.Entity.SuspensionAddHeight = SuspensionAddHeight	
		trace.Entity:SetHydraulicActive( Active )
		trace.Entity.HydraulicActive = Active	
		trace.Entity:SetSoftnesFront( SoftnesFront )
		trace.Entity.SoftnesFront = SoftnesFront
		trace.Entity:SetSoftnesRear( SoftnesRear )
		trace.Entity.SoftnesRear = SoftnesRear		
		trace.Entity:SetHeightFront( NewHeightFront )
		trace.Entity.HeightFront = HeightFront
		trace.Entity:SetHeightRear( NewHeightRear )
		trace.Entity.HeightRear = HeightRear	
		trace.Entity:ChangeWheel( model, physMat )
		trace.Entity.WheelModel = model	
		trace.Entity.physMat = physMat	
		trace.Entity:SetFuelConsumptionUse( FuelConsumptionUse )
		trace.Entity.FuelConsumptionUse = FuelConsumptionUse	
		trace.Entity:SetFuelConsumption( FuelConsumption )
		trace.Entity.FuelConsumption = FuelConsumption		
		trace.Entity:SetBreakEfficiency( BreakEfficiency )
		trace.Entity.BreakEfficiency = BreakEfficiency
		trace.Entity:SetReverseForce( ReverseForce )
		trace.Entity.ReverseForce = ReverseForce		
		trace.Entity:SetReverseMaxSpeed( ReverseMaxSpeed )
		trace.Entity.ReverseMaxSpeed = ReverseMaxSpeed 
		trace.Entity:SetTurboEffect( TurboEffect )
		trace.Entity.TurboEffect = TurboEffect		
		trace.Entity:SetTurboDuration( TurboDuration )
		trace.Entity.TurboDuration = TurboDuration	
		trace.Entity:SetTurboDelay( TurboDelay )
		trace.Entity.TurboDelay = TurboDelay	
		trace.Entity:SetAcceleration( Acceleration )		
		trace.Entity.Acceleration = Acceleration
		trace.Entity:SetSteerForce( SteerForce )
		trace.Entity.SteerForce	= SteerForce
		trace.Entity:SetMaxSpeed( MaxSpeed )
		trace.Entity.MaxSpeed = MaxSpeed		
		trace.Entity:SetNrOfGears( NrOfGears )
		trace.Entity.NrOfGears = NrOfGears	
		trace.Entity:SetEngineSound( EngineSound )
		trace.Entity.EngineSound = EngineSound			
		trace.Entity:SetUseRT( useRT )
		trace.Entity.useRT = useRT		
		trace.Entity:SetUseHUD( UseHUD )
		trace.Entity.UseHUD = UseHUD	
		trace.Entity:SetSteerResponse( SteerResponse )
		trace.Entity.SteerResponse = SteerResponse		
		trace.Entity:SetStabilisation( Stabilisation )
		trace.Entity.Stabilisation = Stabilisation				
		trace.Entity:SetThirdPersonView( ThirdPersonView )		
		trace.Entity.ThirdPersonView = ThirdPersonView
		trace.Entity:SetCameraCorrection( CameraCorrection )		
		trace.Entity.CameraCorrection = CameraCorrection
		trace.Entity:SetAntiSlide( AntiSlide )
		trace.Entity.AntiSlide = AntiSlide		
		
		local NrOfSkins = trace.Entity:SkinCount()
		
		if Skin <= NrOfSkins then
			trace.Entity:SetSkin(Skin)
		end
		

		return true
	end
	
	return false
end

function TOOL:RightClick( trace )
	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	if trace.Entity:IsValid() && trace.Entity != NULL && trace.Entity != nil then
	
		local CarHealth  = trace.Entity.CarHealth
		local CanTakeDamage = trace.Entity.CanTakeDamage
		local CanTakeWheelDamage = trace.Entity.CanTakeWheelDamage
		local SuspensionAddHeight  = trace.Entity.SuspensionAddHeight
		local Active 			  = trace.Entity.HydraulicActive	
		local SoftnesFront  = trace.Entity.SoftnesFront
		local SoftnesRear   = trace.Entity.SoftnesRear
		local HeightFront   = trace.Entity.HeightFront
		local HeightRear    = trace.Entity.HeightRear		
		local model   = trace.Entity.WheelModel		
		local physMat = trace.Entity.physMat 	
		local FuelConsumptionUse = trace.Entity.FuelConsumptionUse
		local FuelConsumption = trace.Entity.FuelConsumption
		local BreakEfficiency   = trace.Entity.BreakEfficiency
		local ReverseForce   = trace.Entity.ReverseForce
		local ReverseMaxSpeed = trace.Entity.ReverseMaxSpeed
		local TurboEffect = trace.Entity.TurboEffect
		local TurboDuration = trace.Entity.TurboDuration
		local TurboDelay = trace.Entity.TurboDelay			
		local Acceleration = trace.Entity.Acceleration
		local SteerForce = trace.Entity.SteerForce
		local MaxSpeed = trace.Entity.MaxSpeed
		local NrOfGears = trace.Entity.NrOfGears
		local useRT = trace.Entity.useRT		
		local EngineSound = trace.Entity.EngineSound
		local UseHUD = trace.Entity.UseHUD
		local SteerResponse = trace.Entity.SteerResponse
		local Stabilisation = trace.Entity.Stabilisation
		local ThirdPersonView = trace.Entity.ThirdPersonView		
		local CameraCorrection = trace.Entity.CameraCorrection
		local AntiSlide = trace.Entity.AntiSlide
		local Skin = trace.Entity:GetSkin()

		self:GetOwner():ConCommand("carpresets_CarHealth "..CarHealth)
		self:GetOwner():ConCommand("carpresets_CanTakeDamage "..CanTakeDamage)
		self:GetOwner():ConCommand("carpresets_CanTakeWheelDamage "..CanTakeWheelDamage)
		self:GetOwner():ConCommand("carpresets_SuspensionAddHeight "..SuspensionAddHeight)
		self:GetOwner():ConCommand("carpresets_Active "..Active)		
		self:GetOwner():ConCommand("carpresets_SoftnesFront "..SoftnesFront)
		self:GetOwner():ConCommand("carpresets_SoftnesRear "..SoftnesRear)
		self:GetOwner():ConCommand("carpresets_HeightFront "..HeightFront)
		self:GetOwner():ConCommand("carpresets_HeightRear "..HeightRear)		
		self:GetOwner():ConCommand("carpresets_physmaterial "..physMat)			
		self:GetOwner():ConCommand("carpresets_model "..model)	
		self:GetOwner():ConCommand("carpresets_FuelConsumptionUse "..FuelConsumptionUse)
		self:GetOwner():ConCommand("carpresets_FuelConsumption "..FuelConsumption)			
		self:GetOwner():ConCommand("carpresets_Skin "..Skin)				
		self:GetOwner():ConCommand("carpresets_BreakEfficiency "..BreakEfficiency)
		self:GetOwner():ConCommand("carpresets_ReverseForce "..ReverseForce)
		self:GetOwner():ConCommand("carpresets_ReverseMaxSpeed "..ReverseMaxSpeed)
		self:GetOwner():ConCommand("carpresets_TurboEffect "..TurboEffect)
		self:GetOwner():ConCommand("carpresets_TurboDuration "..TurboDuration)
		self:GetOwner():ConCommand("carpresets_TurboDelay "..TurboDelay)
		self:GetOwner():ConCommand("carpresets_Acceleration "..Acceleration)
		self:GetOwner():ConCommand("carpresets_SteerForce "..SteerForce)		
		self:GetOwner():ConCommand("carpresets_MaxSpeed "..MaxSpeed)
		self:GetOwner():ConCommand("carpresets_NrOfGears "..NrOfGears)
		self:GetOwner():ConCommand("carpresets_useRT "..useRT)
		self:GetOwner():ConCommand("carpresets_soundname "..EngineSound)
		self:GetOwner():ConCommand("carpresets_UseHUD "..UseHUD)	
		self:GetOwner():ConCommand("carpresets_SteerResponse "..SteerResponse)
		self:GetOwner():ConCommand("carpresets_Stabilisation "..Stabilisation)
		self:GetOwner():ConCommand("carpresets_ThirdPersonView "..ThirdPersonView)
		self:GetOwner():ConCommand("carpresets_CameraCorrection "..CameraCorrection)
		self:GetOwner():ConCommand("carpresets_AntiSlide "..AntiSlide)			
		
		
		return true
	end
	
	
	return false
end

function TOOL.BuildCPanel( CPanel )
	
	local params = { Label = "#Presets", MenuButton = 1, Folder = "SCars", Options = {}, CVars = {} }
			
		params.Options.default = {
			carpresets_CarHealth    = 200,
			carpresets_CanTakeDamage = 1,
			carpresets_CanTakeWheelDamage = 1,			
			carpresets_SuspensionAddHeight    = 0,
			carpresets_Active = 0,			
			carpresets_SoftnesFront = 0,
			carpresets_SoftnesRear = 0,
			carpresets_liveAction = 0,
			carpresets_liveAction2 = 0,	
			carpresets_HeightFront = 0,
			carpresets_HeightRear = 0,			
			carpresets_Skin = 0,		
			carpresets_model    = "models/props_vehicles/carparts_wheel01a.mdl",
			carpresets_select   = 1,
			carpresets_physmaterial = "rubber",	
			carpresets_FuelConsumptionUse = 0,
			carpresets_FuelConsumption = 100,
			carpresets_BreakEfficiency    = 10,
			carpresets_ReverseForce   = 1000,
			carpresets_ReverseMaxSpeed = 200,
			carpresets_TurboEffect = 2,
			carpresets_TurboDuration = 5,
			carpresets_TurboDelay = 5,
			carpresets_Acceleration = 3000,
			carpresets_SteerForce = 5,
			carpresets_MaxSpeed = 1500,
			carpresets_NrOfGears = 5,
			carpresets_soundname = "vehicles/Airboat/fan_motor_idle_loop1.wav",
			carpresets_useRT = 0,
			carpresets_UseHUD = 1,
			carpresets_SteerResponse = 0.3,
			carpresets_Stabilisation = 0,
			carpresets_ThirdPersonView = 0,
			carpresets_CameraCorrection = 0,
			carpresets_AntiSlide = 0,					
		}


		table.insert( params.CVars, "carpresets_CarHealth")
		table.insert( params.CVars, "carpresets_CanTakeDamage")
		table.insert( params.CVars, "carpresets_CanTakeWheelDamage")
		table.insert( params.CVars, "carpresets_SuspensionAddHeight")
		table.insert( params.CVars, "carpresets_Active")		
		table.insert( params.CVars, "carpresets_SoftnesFront")
		table.insert( params.CVars, "carpresets_SoftnesRear")
		table.insert( params.CVars, "carpresets_HeightFront")
		table.insert( params.CVars, "carpresets_HeightRear")		
		table.insert( params.CVars, "carpresets_physmaterial")			
		table.insert( params.CVars, "carpresets_model")	
		table.insert( params.CVars, "carpresets_FuelConsumptionUse")
		table.insert( params.CVars, "carpresets_FuelConsumption")			
		table.insert( params.CVars, "carpresets_Skin")				
		table.insert( params.CVars, "carpresets_BreakEfficiency")
		table.insert( params.CVars, "carpresets_ReverseForce")
		table.insert( params.CVars, "carpresets_ReverseMaxSpeed")
		table.insert( params.CVars, "carpresets_TurboEffect")
		table.insert( params.CVars, "carpresets_TurboDuration")
		table.insert( params.CVars, "carpresets_TurboDelay")
		table.insert( params.CVars, "carpresets_Acceleration")
		table.insert( params.CVars, "carpresets_SteerForce")		
		table.insert( params.CVars, "carpresets_MaxSpeed")
		table.insert( params.CVars, "carpresets_NrOfGears")
		table.insert( params.CVars, "carpresets_useRT")
		table.insert( params.CVars, "carpresets_soundname")
		table.insert( params.CVars, "carpresets_UseHUD")	
		table.insert( params.CVars, "carpresets_SteerResponse")
		table.insert( params.CVars, "carpresets_Stabilisation")
		table.insert( params.CVars, "carpresets_ThirdPersonView")
		table.insert( params.CVars, "carpresets_CameraCorrection")
		table.insert( params.CVars, "carpresets_AntiSlide")
						
	CPanel:AddControl( "ComboBox", params )


end