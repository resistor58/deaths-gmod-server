
TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Tuner"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
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
	AutoStraighten = "0",
}


if CLIENT then
	language.Add( "Tool_Car_BreakEfficiency", "Break Efficiency:" )
	language.Add( "Tool_Car_ReverseForce", "Reverse Power:" )	
	language.Add( "Tool_Car_ReverseMaxSpeed", "Reverse Max Speed:" )		
	language.Add( "Tool_Car_TurboEffect", "Turbo Effect (multiplier):" )
	language.Add( "Tool_Car_TurboDuration", "Turbo Duration (in seconds):" )
	language.Add( "Tool_Car_TurboDelay", "Turbo Delay (in seconds):" )	
	language.Add( "Tool_Car_Acceleration", "Power:" )
	language.Add( "Tool_Car_SteerForce", "Steer Force:" )	
	language.Add( "Tool_Car_MaxSpeed", "Max Speed:" )
	language.Add( "Tool_Car_NrOfGears", "Nr Of Gears:" )		
	language.Add( "Tool_Car_Sounds", "Engine Sound:" )	
	language.Add( "Tool_Car_SteerResponse", "Steer Response:" )	
	language.Add( "Tool_Car_Stabilisation", "Stabilisation:" )	
	language.Add( "Tool_Car_AntiSlide", "AntiSlide:" )	
	language.Add( "Tool_Car_AutoStraighten", "AutoStraighten:" )	
	
	language.Add( "Tool_Car_rtlamps", "Use RT lamps" )
	language.Add( "Tool_Car_rtlamps_desc", "Turn RT lamps on or off" )
	
	language.Add( "Tool_Car_hud", "Use HUD" )
	language.Add( "Tool_Car_hud_desc", "Turn the HUD on or off" )

	language.Add( "Tool_Car_ThirdPersonView", "Use Third Person View" )
	language.Add( "Tool_Car_ThirdPersonView_desc", "Turn the third person view on or off" )

	language.Add( "Tool_Car_CameraCorrection", "Use Camera Correction" )
	language.Add( "Tool_Car_CameraCorrection_desc", "Camera Correction will help you turn your head" )
	
	language.Add( "Tool_cartuning_name", "Car Tuner" )
	language.Add( "Tool_cartuning_desc", "Can tune cars with it" )
	language.Add( "Tool_cartuning_0", "Primary fire to paste and secondary fire to copy" )
	
end

function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
		local pos =  trace.Entity:WorldToLocal( trace.HitPos )
	
	
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	// If we shot a 
	if trace.Entity:IsValid()  then

		//Getting all the values and check all limitations
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
		local AutoStraighten = self:GetClientNumber( "AutoStraighten" )
		
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
		local LimitMaxAutoStraighten = GetConVarNumber("scar_maxautostraighten")--Max AutoStraighten
		local maxAcc = GetConVarNumber("SCar_Acceleration")
		
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

		if AutoStraighten > LimitMaxAutoStraighten then
			AutoStraighten = LimitMaxAutoStraighten
		end
		
		if Acceleration > maxAcc then 
			Acceleration = maxAcc 
		end

		trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))
	
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
		
		--trace.Entity:SetUseRT( useRT )
		--trace.Entity.useRT = useRT	
		
		trace.Entity:SetUseHUD( UseHUD )
		trace.Entity.UseHUD = UseHUD	

		trace.Entity:SetSteerResponse( SteerResponse )
		trace.Entity.SteerResponse = SteerResponse		

		trace.Entity:SetStabilisation( Stabilisation )
		trace.Entity.Stabilisation = Stabilisation			
		
		--trace.Entity:SetThirdPersonView( ThirdPersonView )		
		--trace.Entity.ThirdPersonView = ThirdPersonView

		--trace.Entity:SetCameraCorrection( CameraCorrection )		
		--trace.Entity.CameraCorrection = CameraCorrection
		
		trace.Entity:SetAntiSlide( AntiSlide )
		trace.Entity.AntiSlide = AntiSlide
		
		trace.Entity.AutoStraighten = AutoStraighten
		
		return true

	end
	return true

end

function TOOL:RightClick( trace )
	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	if trace.Entity:IsValid() && trace.Entity != NULL && trace.Entity != nil then

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
		local AutoStraighten = trace.Entity.AutoStraighten
		
		self:GetOwner():ConCommand("cartuning_BreakEfficiency "..BreakEfficiency)
		self:GetOwner():ConCommand("cartuning_ReverseForce "..ReverseForce)
		self:GetOwner():ConCommand("cartuning_ReverseMaxSpeed "..ReverseMaxSpeed)
		self:GetOwner():ConCommand("cartuning_TurboEffect "..TurboEffect)
		self:GetOwner():ConCommand("cartuning_TurboDuration "..TurboDuration)
		self:GetOwner():ConCommand("cartuning_TurboDelay "..TurboDelay)
		self:GetOwner():ConCommand("cartuning_Acceleration "..Acceleration)
		self:GetOwner():ConCommand("cartuning_SteerForce "..SteerForce)		
		self:GetOwner():ConCommand("cartuning_MaxSpeed "..MaxSpeed)
		self:GetOwner():ConCommand("cartuning_NrOfGears "..NrOfGears)
		--self:GetOwner():ConCommand("cartuning_useRT "..useRT)
		self:GetOwner():ConCommand("cartuning_soundname "..EngineSound)
		self:GetOwner():ConCommand("cartuning_UseHUD "..UseHUD)	
		self:GetOwner():ConCommand("cartuning_SteerResponse "..SteerResponse)
		self:GetOwner():ConCommand("cartuning_Stabilisation "..Stabilisation)
		--self:GetOwner():ConCommand("cartuning_ThirdPersonView "..ThirdPersonView)
		--self:GetOwner():ConCommand("cartuning_CameraCorrection "..CameraCorrection)
		self:GetOwner():ConCommand("cartuning_AntiSlide "..AntiSlide)		
		self:GetOwner():ConCommand("cartuning_AutoStraighten "..AutoStraighten)			
		return true
	end
	
	
	return true
end

function TOOL.BuildCPanel( CPanel )
	
	// HEADER
	CPanel:AddControl( "Header", { Text = "Carframes", Description	= "Spawn carframes" }  )	
	
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_Acceleration",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 10000,
									 Command = "cartuning_Acceleration" } )		
								 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_MaxSpeed",
									 Description = "",
									 Type = "float",
									 Min = 10,
									 Max = 5000,
									 Command = "cartuning_MaxSpeed" } )	

CPanel:AddControl( "Label", { Text = "________________________________________", Description = "" } )	

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_TurboEffect",
									 Description = "",
									 Type = "float",
									 Min = 1,
									 Max = 5,
									 Command = "cartuning_TurboEffect" } )

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_TurboDuration",
									 Description = "",
									 Type = "float",
									 Min = 1,
									 Max = 10,
									 Command = "cartuning_TurboDuration" } )

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_TurboDelay",
									 Description = "",
									 Type = "float",
									 Min = 1,
									 Max = 60,
									 Command = "cartuning_TurboDelay" } )									 
									 
									 
CPanel:AddControl( "Label", { Text = "________________________________________", Description = "" } )										 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_ReverseForce",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 5000,
									 Command = "cartuning_ReverseForce" } )					 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_ReverseMaxSpeed",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 1000,
									 Command = "cartuning_ReverseMaxSpeed" } )								 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_BreakEfficiency",
									 Description = "",
									 Type = "float",
									 Min = 0.5,
									 Max = 4,
									 Command = "cartuning_BreakEfficiency" } )
									 
CPanel:AddControl( "Label", { Text = "________________________________________", Description = "" } )											 
					 								 									 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_SteerForce",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 20,
									 Command = "cartuning_SteerForce" } )										 

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_SteerResponse",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 2,
									 Command = "cartuning_SteerResponse" } )										 

CPanel:AddControl( "Label", { Text = "________________________________________", Description = "" } )

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_Stabilisation",
									 Description = "",
									 Type = "int",
									 Min = 0,
									 Max = 3000,
									 Command = "cartuning_Stabilisation" } )									 		 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_NrOfGears",
									 Description = "",
									 Type = "int",
									 Min = 1,
									 Max = 10,
									 Command = "cartuning_NrOfGears" } )									 

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_AntiSlide",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 50,
									 Command = "cartuning_AntiSlide" } )			

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_AutoStraighten",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 50,
									 Command = "cartuning_AutoStraighten" } )
									 										 
	--[[	
	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_rtlamps",
									 Description = "#Tool_Car_rtlamps_desc",
									 Command = "cartuning_useRT" } )	
									 ]]--

	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_hud",
									 Description = "#Tool_Car_hud_desc",
									 Command = "cartuning_UseHUD" } )

	--[[
	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_ThirdPersonView",
									 Description = "#Tool_Car_ThirdPersonView_desc",
									 Command = "cartuning_ThirdPersonView" } )

	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_CameraCorrection",
									 Description = "#Tool_Car_CameraCorrection_desc",
									 Command = "cartuning_CameraCorrection" } )
									 --]]
									 
	CPanel:AddControl( "Label", { Text = "Engine sound", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#Tool_Car_Sounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "EngineSounds" ) } )									 
									 
end


list.Set( "EngineSounds", "#V8 cruise", { cartuning_soundname = "vehicles/v8/fourth_cruise_loop2.wav" } )
list.Set( "EngineSounds", "#V8 first gear", { cartuning_soundname = "vehicles/v8/v8_firstgear_rev_loop1.wav" } )
list.Set( "EngineSounds", "#V8 start", { cartuning_soundname = "vehicles/v8/v8_start_loop1.wav" } )
list.Set( "EngineSounds", "#Crane ", { cartuning_soundname = "vehicles/Crane/crane_extend_loop1.wav" } )
list.Set( "EngineSounds", "#Crane idle", { cartuning_soundname = "vehicles/Crane/crane_slow_to_idle_loop4.wav" } )
list.Set( "EngineSounds", "#APC cruise", { cartuning_soundname = "vehicles/APC/apc_cruise_loop3.wav" } )
list.Set( "EngineSounds", "#Diesel", { cartuning_soundname = "vehicles/diesel_loop2.wav" } )
list.Set( "EngineSounds", "#Digger", { cartuning_soundname = "vehicles/digger_grinder_loop1.wav" } )
list.Set( "EngineSounds", "#Airboat fan full Throttle", { cartuning_soundname = "vehicles/Airboat/fan_blade_fullthrottle_loop1.wav" } )
list.Set( "EngineSounds", "#Airboat fan idle", { cartuning_soundname = "vehicles/Airboat/fan_blade_idle_loop1.wav" } )
list.Set( "EngineSounds", "#Airboat full Throttle", { cartuning_soundname = "vehicles/Airboat/fan_motor_fullthrottle_loop1.wav" } )
list.Set( "EngineSounds", "#Airboat idle", { cartuning_soundname = "vehicles/Airboat/fan_motor_idle_loop1.wav" } )
list.Set( "EngineSounds", "#Ratmobile", { cartuning_soundname = "vehicles/Ratmobile/fourth_cruise_loop2.wav" } )
list.Set( "EngineSounds", "#Hedgehog", { cartuning_soundname = "vehicles/Hedgehog/fourth_cruise_loop2.wav" } )
list.Set( "EngineSounds", "#Chaos126p", { cartuning_soundname = "vehicles/Chaos126p/fourth_cruise_loop2.wav" } )