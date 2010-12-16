require("datastream")

TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#SCar Saver"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ScarAttatchments = {}
TOOL.ScarAttatchmentsOldCol = {}
TOOL.ScarAttatchmentsOldMat = {}
TOOL.NrOfAttatchments = 0

TOOL.SCarParent = NULL
TOOL.OldSCarCol = Color(255,255,255,255)
TOOL.OldSCarMat = NULL

TOOL.UseMode = false
TOOL.UseModeDel = CurTime()

TOOL.nrOfScarProperties = 36
TOOL.nrOfProperties = 15
TOOL.SepSign = "¤"

TOOL.SaveDir = "scarsave/"

TOOL.SaveDel = CurTime()
--Buttons
TOOL.savebutt = 0
TOOL.loadbutt = 0
TOOL.deletebutt = 0
TOOL.uploadbutt = 0

TOOL.ClientConVar = {
	fileName    = "None",
	saveToFile = "0",
	deleteFile = "0",
	loadFile = "0",
	uploadFile = "0",
	restorePhysics = "0"
}

if CLIENT then
	
	language.Add( "Tool_savescar_name", "Car Saver" )
	language.Add( "Tool_savescar_desc", "Save SCars" )
	language.Add( "Tool_savescar_0", "Primary fire: Select part , Secodary: De-select part" )
	
end

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if (CLIENT) then return true end

	return self:AddItem(trace.Entity)

end

function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if (CLIENT) then return true end
	
	self:DeselectAll()
	return true

end

function TOOL:Reload(trace)

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if (CLIENT) then return true end
	
	if ValidEntity(trace.Entity) then
	
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_car" ) or string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
		local isWeirdProp = trace.Entity:GetCollisionGroup()
		local phys = trace.Entity:GetPhysicsObject()
		
		if isWeirdProp == 20 && trace.Entity:GetClass() == "prop_physics" then
			phys:SetPos( trace.Entity:GetPos() )
			phys:SetAngle( trace.Entity:GetAngles() )
			trace.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
		end
	
		trace.Entity:SetParent(NULL)
		constraint.RemoveAll( trace.Entity )
		phys:Wake()
		
		   undo.Create("prop")
			undo.AddEntity(trace.Entity)
			undo.SetPlayer(self:GetOwner())
		undo.Finish()

		
		return true
	end
end


function TOOL:Think()

	if (SERVER) then
		local shouldSave = self:GetClientNumber( "saveToFile" ) 
		local shouldDelete = self:GetClientNumber( "deleteFile" ) 
		local shouldLoad = self:GetClientNumber( "loadFile" )  
		local shouldUpload = self:GetClientNumber( "uploadFile" )  
		
		if self.savebutt != shouldSave && shouldSave == 1 then
			self.savebutt = shouldSave
			self:SaveToFile()
			self:GetOwner():ConCommand("savescar_saveToFile 0")
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		elseif self.savebutt != shouldSave && shouldSave == 0 then
			self.savebutt = shouldSave
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		end

		if self.deletebutt != shouldDelete && shouldDelete == 1 then
			self.deletebutt = shouldDelete
			self:DeleteFile()
			self:GetOwner():ConCommand("savescar_deleteFile 0")
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		elseif self.deletebutt != shouldDelete && shouldDelete == 0 then
			self.deletebutt = shouldDelete
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		end
	
		if self.loadbutt != shouldLoad && shouldLoad == 1 then
			self.loadbutt = shouldLoad
			self:LoadFile()
			self:GetOwner():ConCommand("savescar_loadFile 0")
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		elseif self.loadbutt != shouldLoad && shouldLoad == 0 then
			self.loadbutt = shouldLoad
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		end	

		if self.uploadbutt != shouldUpload && shouldUpload == 1 then
			self.uploadbutt = shouldUpload
			self:UploadFile()
			self:GetOwner():ConCommand("savescar_uploadFile 0")
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		elseif self.uploadbutt != shouldUpload && shouldUpload == 0 then
			self.uploadbutt = shouldUpload
			self:GetOwner():SendLua( "RebuildSCarControlPanel()" )
		end			
		
	end
	
end


function TOOL.BuildCPanel( CPanel )			 

  local CPanel = GetControlPanel( "savescar" )
  if CPanel then CPanel:ClearControls() end
  


	--Textbox
	local TextBox = {}
	TextBox.Label = ""
	TextBox.Description = ""
	TextBox.MaxLength = 20
	TextBox.Text = "Hello?"
	TextBox.Command = "savescar_fileName"
	TextBox.WaitForEnter = true
	
	CPanel:AddControl("TextBox", TextBox)	
	
	
	--Save button
	local saveButton = {}
	saveButton.Label = "Save"
	saveButton.Description = "Press this button to save"
	saveButton.Text = "Blah"
	saveButton.Command = "savescar_saveToFile 1"
	CPanel:AddControl("Button", saveButton)	
	
	
	--List
	local ListBox = {}
	ListBox.Label = ""
	ListBox.Description = ""
	ListBox.MenuButton = true
	ListBox.Height = 500
	ListBox.Options = {}
	
	local list = file.Find("scarsave/*.txt")
	local nr = table.Count(list)
	
	
	
	for i = 1, nr do
		local opName = string.Explode(".", list[i])	
		ListBox.Options[opName[1]] = { savescar_fileName = list[i] }
	end
	 
	CPanel:AddControl("ListBox", ListBox)	

	--Load button
	local loadButton = {}
	loadButton.Label = "Load"
	loadButton.Description = "Press this button to Load"
	loadButton.Text = "Blah"
	loadButton.Command = "savescar_loadFile 1"
	CPanel:AddControl("Button", loadButton)		
	
	
	local deleteButton = {}
	deleteButton.Label = "Delete"
	deleteButton.Description = "Press this button to Delete"
	deleteButton.Text = "Delete"
	deleteButton.Command = "savescar_deleteFile 1"
	CPanel:AddControl("Button", deleteButton)		

	if !SinglePlayer() then
		local uploadButton = {}
		uploadButton.Label = "Upload"
		uploadButton.Description = "Press this button to Upload to server"
		uploadButton.Text = "Upload"
		uploadButton.Command = "savescar_uploadFile 1"
		CPanel:AddControl("Button", uploadButton)
	end
	
	local checkBox = {}
	checkBox.Label = "Try to keep physics"
	checkBox.Description = "parenting with physics or not"
	checkBox.Command = "savescar_restorePhysics"
	CPanel:AddControl("CheckBox", checkBox)

end




function TOOL:AddItem(item)
	
	local succeded = false
	
	if ValidEntity(item) then
	if string.find( item:GetClass( ), "sent_sakarias_carwheel" ) or string.find( item:GetClass( ), "sent_Sakarias_carwheel_punked" ) or item.IsDestroyed == 1 then return false end 
	
	
		if string.find( item:GetClass( ), "sent_sakarias_car" ) then
		
			--Deselecting SCar
			if ValidEntity(self.SCarParent) && self.SCarParent:EntIndex() == item:EntIndex() then
				self.SCarParent:SetColor(self.OldSCarCol.r, self.OldSCarCol.g, self.OldSCarCol.b, self.OldSCarCol.a)
				self.SCarParent:SetMaterial(self.OldSCarMat)
				self.SCarParent = NULL
			else
				if ValidEntity(self.SCarParent) then
					self.SCarParent:SetColor(self.OldSCarCol.r, self.OldSCarCol.g, self.OldSCarCol.b, self.OldSCarCol.a)
					self.SCarParent = NULL		
					self.SCarParent:SetMaterial(self.OldSCarMat)
				end
			
				local colR, colG, colB, colA = item:GetColor()
				self.OldSCarCol = Color(colR, colG, colB, colA)
				self.OldSCarMat = item:GetMaterial()
				item:SetMaterial("models/debug/debugwhite")
				item:SetColor(255,0,0,100)
				self.SCarParent = item
			end
		
			succeded = true
		else
			local add = true
			for i = 1, self.NrOfAttatchments do
				
				if ValidEntity(self.ScarAttatchments[i]) && self.ScarAttatchments[i]:EntIndex() == item:EntIndex() then
					add = false
					
					--deselect the item
					self.ScarAttatchments[i]:SetMaterial( self.ScarAttatchmentsOldMat[i] )
					self.ScarAttatchments[i]:SetColor(self.ScarAttatchmentsOldCol[i].r, self.ScarAttatchmentsOldCol[i].g, self.ScarAttatchmentsOldCol[i].b, self.ScarAttatchmentsOldCol[i].a )
					self.ScarAttatchments[i] = self.ScarAttatchments[self.NrOfAttatchments]
					self.ScarAttatchmentsOldCol[i] = self.ScarAttatchmentsOldCol[self.NrOfAttatchments]
					self.ScarAttatchmentsOldMat[i] = self.ScarAttatchmentsOldMat[self.NrOfAttatchments]
					self.NrOfAttatchments = self.NrOfAttatchments - 1
					succeded = true
				end
			end
			
			if add == true then
				self.NrOfAttatchments = self.NrOfAttatchments + 1
				local colR, colG, colB, colA = item:GetColor()
				self.ScarAttatchmentsOldMat[self.NrOfAttatchments] = item:GetMaterial()
				self.ScarAttatchmentsOldCol[self.NrOfAttatchments] = Color(colR, colG, colB, colA)
				self.ScarAttatchments[self.NrOfAttatchments] = item
				item:SetColor(255,0,0,100)
				item:SetMaterial("models/debug/debugwhite")
				succeded = true 
			end
		end	
	end
	
	return succeded
end


function TOOL:DeselectAll()

	for i = 1, self.NrOfAttatchments do
		if ValidEntity(self.ScarAttatchments[i]) then
			self.ScarAttatchments[i]:SetColor(self.ScarAttatchmentsOldCol[i].r, self.ScarAttatchmentsOldCol[i].g, self.ScarAttatchmentsOldCol[i].b, self.ScarAttatchmentsOldCol[i].a )
			self.ScarAttatchments[i]:SetMaterial( self.ScarAttatchmentsOldMat[i] )
		end
	end
	self.NrOfAttatchments = 0

	if ValidEntity(self.SCarParent) then
		self.SCarParent:SetColor(self.OldSCarCol.r, self.OldSCarCol.g, self.OldSCarCol.b, self.OldSCarCol.a)
		self.SCarParent:SetMaterial(self.OldSCarMat)
		self.SCarParent = NULL	
	end
	
end

function TOOL:SaveToFile()

	--Getting all selected props
	--Putting the information we need in a string and sends it to client
	--Client will then save it as a txt

	
	if ValidEntity(self.SCarParent) then

		local filename = self:GetClientInfo( "fileName" )
		local ply = self:GetOwner()
		local str = ""
		
		--The pain!
		str = self.SCarParent:GetClass()..self.SepSign..self.SCarParent.BreakEfficiency..self.SepSign..self.SCarParent.ReverseForce..self.SepSign..self.SCarParent.ReverseMaxSpeed..self.SepSign..self.SCarParent.TurboEffect..self.SepSign
		str = str..self.SCarParent.Acceleration..self.SepSign..self.SCarParent.SteerForce..self.SepSign..self.SCarParent.MaxSpeed..self.SepSign..self.SCarParent.NrOfGears..self.SepSign..self.SCarParent.EngineSound..self.SepSign
		str = str..self.SCarParent.SoftnesFront..self.SepSign..self.SCarParent.SoftnesRear..self.SepSign..self.SCarParent.HeightFront..self.SepSign..self.SCarParent.HeightRear..self.SepSign..self.SCarParent.WheelModel..self.SepSign..self.SCarParent.physMat..self.SepSign
		str = str..self.SCarParent.HydraulicHeight..self.SepSign..self.SCarParent.HydraulicActive..self.SepSign..self.SCarParent.TurboDuration..self.SepSign..self.SCarParent.TurboDelay..self.SepSign..self.SCarParent.CarMaxHealth..self.SepSign		
		str = str..self.SCarParent.CanTakeDamage..self.SepSign..self.SCarParent.CanTakeWheelDamage..self.SepSign..self.SCarParent.UseHud..self.SepSign..self.SCarParent.UsesFuelConsumption..self.SepSign..self.SCarParent.FuelConsumption..self.SepSign	
		str = str..self.SCarParent.Stabilisation..self.SepSign..self.SCarParent.AntiSlide..self.SepSign..self.SCarParent.SteerResponse..self.SepSign..self.SCarParent.AutoStraighten..self.SepSign..self.SCarParent:GetSkin()..self.SepSign..self.OldSCarMat..self.SepSign
		str = str..self.OldSCarCol.r..self.SepSign..self.OldSCarCol.g..self.SepSign..self.OldSCarCol.b..self.SepSign..self.OldSCarCol.a..self.SepSign

--[[		
self.SCarParent.BreakEfficiency
self.SCarParent.ReverseForce
self.SCarParent.ReverseMaxSpeed
self.SCarParent.TurboEffect
self.SCarParent.Acceleration
self.SCarParent.SteerForce
self.SCarParent.MaxSpeed
self.SCarParent.NrOfGears
self.SCarParent.EngineSound
self.SCarParent.SoftnesFront
self.SCarParent.SoftnesRear
self.SCarParent.HeightFront
self.SCarParent.HeightRear
self.SCarParent.WheelModel
self.SCarParent.physMat
self.SCarParent.HydraulicHeight
self.SCarParent.HydraulicActive
self.SCarParent.TurboDuration
self.SCarParent.TurboDelay
self.SCarParent.CarMaxHealth
self.SCarParent.CanTakeDamage
self.SCarParent.CanTakeWheelDamage
self.SCarParent.UseHud
self.SCarParent.UsesFuelConsumption
self.SCarParent.FuelConsumption
self.SCarParent.Stabilisation
self.SCarParent.AntiSlide
self.SCarParent.SteerResponse	
self.SCarParent.AutoStraighten
]]--

		--Adding the weapon system is there is one
		if ValidEntity(self.SCarParent.WeaponSystem) then
			local succ = self:AddItem(self.SCarParent.WeaponSystem)	
		end
		
		--Filling it with all attatched props
		for i = 1, self.NrOfAttatchments do
			
			local class = self.ScarAttatchments[i]:GetClass()
			local model = self.ScarAttatchments[i]:GetModel()
			local mat = self.ScarAttatchmentsOldMat[i]
			local skin = self.ScarAttatchments[i]:GetSkin()
			
			local colR = self.ScarAttatchmentsOldCol[i].r
			local colG = self.ScarAttatchmentsOldCol[i].g
			local colB = self.ScarAttatchmentsOldCol[i].b
			local colA = self.ScarAttatchmentsOldCol[i].a			
			local pos = self.SCarParent:WorldToLocal( self.ScarAttatchments[i]:GetPos() )  
			local ang = self.SCarParent:WorldToLocalAngles( self.ScarAttatchments[i]:GetAngles() )
			local mass = self.SCarParent:GetPhysicsObject():GetMass()

			str = str..class..self.SepSign..model..self.SepSign..mat..self.SepSign..skin..self.SepSign..colR..self.SepSign..colG..self.SepSign..colB..self.SepSign..colA..self.SepSign..pos.x..self.SepSign..pos.y..self.SepSign..pos.z..self.SepSign..ang.p..self.SepSign..ang.y..self.SepSign..ang.r..self.SepSign..mass..self.SepSign 			
		end

		if SinglePlayer( ) then
			filename = filename..".txt"
			file.Write(self.SaveDir..filename, str)
		else
			datastream.StreamToClients( ply, "SCarSaveSendClientFile", { str, filename } )
		end
	end	
	
	self:DeselectAll()
end

function TOOL:LoadFile()

	local ply = self:GetOwner()
	local MaxCarsAllowed  = GetConVarNumber( "scar_maxscars" )
	local nrOfCars = ply:GetCount( "SCar" )   
	   
	if nrOfCars >= MaxCarsAllowed - 1 then 	
		ply:PrintMessage( HUD_PRINTTALK, "You have reached SCar spawn limit")
		return false 
	end


	local filename = self:GetClientInfo( "fileName" )
	local keepPhysics = self:GetClientNumber( "restorePhysics" )
	self.nrOfWeps = 0
	self.wepSys = NULL
	
	
	--Load the file
	if file.Exists(self.SaveDir..filename) then
		local cont = file.Read(self.SaveDir..filename)
		local class = NULL
		local model = NULL
		local mat = NULL
		local skin = NULL
		local colR, colG, colB, colA = NULL
		local pos = NULL
		local ang = NULL
		local mass = NULL
		local CarEnt = NULL
		
		local weps = {}
		local nrOfWeps = 0
		local wepPos = {}
		local wepAng = {}
		local wepSys = NULL
		
		if cont && cont != nil && ValidEntity(ply) then
		
			local tracedata = {}
			tracedata.start = ply:GetShootPos()
			tracedata.endpos = ply:GetShootPos() + (ply:GetAimVector() * 1000000)
			tracedata.filter = ply
			local trace = util.TraceLine(tracedata)
			
			ang = trace.HitNormal:Angle()
			ang.pitch = ang.pitch + 90
			local plyAng = ply:GetAimVector():Angle()
			ang.y = plyAng.y
		
			local info = string.Explode(self.SepSign, cont)		
			local nr =  table.Count(info)
			
			class = info[1]
			local addHeight = SakariasSCar_GetSpawnHeightLowerCase( class )
			
			CarEnt = ents.Create( class )
			CarEnt:Spawn()
			CarEnt:SetPos( trace.HitPos + Vector(0,0, addHeight))	
			CarEnt:SetAngles( ang )	
			CarEnt.handBreakDel = CurTime() + 2
			CarEnt.spawnedBy = ply	

			CarEnt:SetCarOwner( ply )
			CarEnt:Reposition( ply )
			CarEnt:UpdateAllCharacteristics()	
			
			ply:AddCount( "SCar", CarEnt )	
			undo.Create("Cars")
			undo.AddEntity( CarEnt )
			undo.SetPlayer( ply )
			undo.Finish()

			--Setting SCar properties
			CarEnt:SetBreakEfficiency( self:StringToNumber(info[2]) )
			CarEnt.BreakEfficiency = self:StringToNumber(info[2])		

			CarEnt:SetReverseForce( self:StringToNumber(info[3]) )
			CarEnt.ReverseForce = self:StringToNumber(info[3])				

			CarEnt:SetReverseMaxSpeed( self:StringToNumber(info[4]) )
			CarEnt.ReverseMaxSpeed = self:StringToNumber(info[4]) 		

			CarEnt:SetTurboEffect( self:StringToNumber(info[5]) )
			CarEnt.TurboEffect = self:StringToNumber(info[5])	

			CarEnt:SetAcceleration( self:StringToNumber(info[6]) )
			CarEnt.Acceleration = self:StringToNumber(info[6])
			
			CarEnt:SetSteerForce( self:StringToNumber(info[7]) )
			CarEnt.SteerForce	= self:StringToNumber(info[7])		
		
			CarEnt:SetMaxSpeed( self:StringToNumber(info[8]) )
			CarEnt.MaxSpeed = self:StringToNumber(info[8])		
		
			CarEnt:SetNrOfGears( self:StringToNumber(info[9]) )
			CarEnt.NrOfGears = self:StringToNumber(info[9])			
		
			CarEnt:SetEngineSound( info[10] )
			CarEnt.EngineSound = info[10]		

			CarEnt:SetSoftnesFront( self:StringToNumber(info[11]) )
			CarEnt.SoftnesFront = self:StringToNumber(info[11])
		
			CarEnt:SetSoftnesRear( self:StringToNumber(info[12]) )
			CarEnt.SoftnesRear = self:StringToNumber(info[12])	

			CarEnt:SetHeightFront( self:StringToNumber(info[13]) )
			CarEnt.HeightFront = self:StringToNumber(info[13])
		
			CarEnt:SetHeightRear( self:StringToNumber(info[14]) )
			CarEnt.HeightRear = self:StringToNumber(info[14])

			CarEnt:ChangeWheel( info[15], info[16] )
			CarEnt.WheelModel = info[15]	
			CarEnt.physMat = info[16]	
	
			CarEnt:SetSuspensionAddHeight( self:StringToNumber(info[17]) )
			CarEnt.SuspensionAddHeight = self:StringToNumber(info[17])	

			CarEnt:SetHydraulicActive( self:StringToNumber(info[18]) )
			CarEnt.HydraulicActive = self:StringToNumber(info[18])	

			CarEnt:SetTurboDuration( self:StringToNumber(info[19]) )
			CarEnt.TurboDuration = self:StringToNumber(info[19])	

			CarEnt:SetTurboDelay( self:StringToNumber(info[20]) )
			CarEnt.TurboDelay = self:StringToNumber(info[20])	

			CarEnt:SetCarHealth( self:StringToNumber(info[21]) )
			CarEnt.CarHealth = self:StringToNumber(info[21])

			CarEnt:SetCanTakeDamage( self:StringToNumber(info[22]), self:StringToNumber(info[23]) )
			CarEnt.CanTakeDamage = self:StringToNumber(info[22])
			CarEnt.CanTakeWheelDamage = self:StringToNumber(info[23])

			CarEnt:SetUseHUD( self:StringToNumber(info[24]) )
			CarEnt.UseHUD = self:StringToNumber(info[24])	

			CarEnt:SetFuelConsumptionUse( self:StringToNumber(info[25]) )
			CarEnt.FuelConsumptionUse = self:StringToNumber(info[25])
			
			CarEnt:SetFuelConsumption( self:StringToNumber(info[26]) )
			CarEnt.FuelConsumption = self:StringToNumber(info[26])	

			CarEnt:SetStabilisation( self:StringToNumber(info[27]) )
			CarEnt.Stabilisation = self:StringToNumber(info[27])	
			
			CarEnt:SetAntiSlide( self:StringToNumber(info[28]) )
			CarEnt.AntiSlide = self:StringToNumber(info[28])		
			
			CarEnt:SetSteerResponse( self:StringToNumber(info[29]) )
			CarEnt.SteerResponse = self:StringToNumber(info[29])	

			CarEnt.AutoStraighten = self:StringToNumber(info[30])	
			
			CarEnt:SetMaterial(info[32])
			CarEnt:SetSkin(self:StringToNumber(info[31]))
			
			
			CarEnt:SetColor(self:StringToNumber(info[33]), self:StringToNumber(info[34]), self:StringToNumber(info[35]), self:StringToNumber(info[36]))
			
			CarEnt:UpdateAllCharacteristics()			
			--
			local maxSlots = (nr - self.nrOfScarProperties) / self.nrOfProperties
			
			for i = 1, maxSlots do
				local slot = self.nrOfScarProperties + 1 + self.nrOfProperties * ( i - 1 )
				class = info[slot]
				model = info[slot + 1]
				mat = info[slot + 2]
				skin = info[slot + 3]
				colR = info[slot + 4]
				colG = info[slot + 5]
				colB = info[slot + 6]
				colA = info[slot + 7]
				pos = Vector(info[slot+8], info[slot+9], info[slot + 10])
				ang = Angle(info[slot+11], info[slot+12], info[slot + 13])			
				mass = info[slot + 14]
				
				local something = ents.Create( class )
				
				if ValidEntity( something ) then
					something:SetModel( model )
					something:SetMaterial( mat )
					something:SetSkin( skin )
					something:SetColor(colR, colG, colB, colA) 
					something:Spawn()	
					
					if ValidEntity( something:GetPhysicsObject() ) then
					
						if class == "sent_sakarias_weaponsystem" then
							SakariasWeaponSystem_MakeConnection(something, CarEnt)
							wepSys = something						
						elseif string.find(class, "sent_sakarias_weapon_") then
							nrOfWeps = nrOfWeps + 1
							weps[nrOfWeps] = something						
							wepPos[nrOfWeps] = pos
							wepAng[nrOfWeps] = ang
							Msg("Weapon\n")
						else
							something:SetParent( CarEnt )	
							something:SetLocalPos( pos )
							something:SetLocalAngles( ang )				
						end					

						if class == "prop_physics" && keepPhysics == 1 then
						
							phys = something:GetPhysicsObject()
							phys:SetPos( something:GetPos() )
							phys:SetAngle( something:GetAngles() )
							constraint.Weld( CarEnt, something, 0, 0, 0, 1 ) 
							
						elseif class == "prop_physics" && keepPhysics == 0 then
						
							something:SetCollisionGroup( COLLISION_GROUP_WORLD )
							something:GetPhysicsObject():EnableDrag(false)
						end
					else
						something:Remove()					
				    end
				end
			end
			
			
			
			for i = 1, nrOfWeps do
				
				if ValidEntity(weps[i]) then

					--Inverting the y axis just works. Dunno why.
					weps[i]:SetPos( CarEnt:GetPos() + CarEnt:GetForward() * wepPos[i].x + CarEnt:GetRight() * wepPos[i].y * -1 + CarEnt:GetUp() * wepPos[i].z)
					weps[i]:SetAngles( CarEnt:GetAngles() + wepAng[i] ) 					
					constraint.Weld( weps[i] , CarEnt, 0, 0, 0, 1 ) 

					SakariasWeaponSystem_MakeConnection(wepSys, weps[i])
					undo.Create("SCarWeapon")
					undo.AddEntity( weps[i] )
					undo.SetPlayer( self:GetOwner() )
					undo.Finish()	
				end
			end		
			
			if ValidEntity(wepSys) then
				wepSys:SwitchRopeVisibility()
			end
		end	
	else
	
	--File did not exist!
		local ply = self:GetOwner()
		
		if SinglePlayer( ) then
			ply:PrintMessage( HUD_PRINTTALK, "There is no file with such name." )		
		else
			ply:PrintMessage( HUD_PRINTTALK, "File did not exist on server (you have to upload it)" )
				
		end
	
	end
	
end

function TOOL:DeleteFile()

	local filename = self:GetClientInfo( "fileName" )
	local ply = self:GetOwner()

	if SinglePlayer( ) then
	
		if file.Exists( self.SaveDir..filename ) then
			file.Delete( self.SaveDir..filename )
		else
			ply:PrintMessage( HUD_PRINTTALK, "There is no file with such name.")	
		end		
	
	else
		umsg.Start( "SCarSaveCommand", ply )
			umsg.String( "delete"..self.SepSign..filename )
		umsg.End()	
	end
	
end

function TOOL:UploadFile()

	local ply = self:GetOwner()
	local filename = self:GetClientInfo( "fileName" )

	if file.Exists( self.SaveDir..filename ) then
		ply:PrintMessage( HUD_PRINTTALK, "File already existed on server. Overvriting..." )	
	end
	
	umsg.Start( "SCarSaveCommand", ply )
		umsg.String( "require"..self.SepSign..filename )
	umsg.End()		

end


function RebuildSCarControlPanel()
  local CPanel = GetControlPanel( "savescar" )
  if ( !CPanel ) then return end
  CPanel:ClearControls()

 
	--Textbox
	local TextBox = {}
	TextBox.Label = ""
	TextBox.Description = ""
	TextBox.MaxLength = 20
	TextBox.Text = "Hello?"
	TextBox.Command = "savescar_fileName"
	TextBox.WaitForEnter = true
	
	CPanel:AddControl("TextBox", TextBox)	
	
	
	--Save button
	local saveButton = {}
	saveButton.Label = "Save"
	saveButton.Description = "Press this button to save"
	saveButton.Text = "Blah"
	saveButton.Command = "savescar_saveToFile 1"
	CPanel:AddControl("Button", saveButton)	
	
	
	--List
	local ListBox = {}
	ListBox.Label = ""
	ListBox.Description = ""
	ListBox.MenuButton = true
	ListBox.Height = 500
	ListBox.Options = {}
	
	local list = file.Find("scarsave/*.txt")
	local nr = table.Count(list)
	
	
	
	for i = 1, nr do
		local opName = string.Explode(".", list[i])	
		ListBox.Options[opName[1]] = { savescar_fileName = list[i] }
	end
	 
	CPanel:AddControl("ListBox", ListBox)	

	--Load button
	local loadButton = {}
	loadButton.Label = "Load"
	loadButton.Description = "Press this button to Load"
	loadButton.Text = "Blah"
	loadButton.Command = "savescar_loadFile 1"
	CPanel:AddControl("Button", loadButton)		
	
	
	local deleteButton = {}
	deleteButton.Label = "Delete"
	deleteButton.Description = "Press this button to Delete"
	deleteButton.Text = "Delete"
	deleteButton.Command = "savescar_deleteFile 1"
	CPanel:AddControl("Button", deleteButton)		

	if !SinglePlayer() then
		local uploadButton = {}
		uploadButton.Label = "Upload"
		uploadButton.Description = "Press this button to Upload to server"
		uploadButton.Text = "Upload"
		uploadButton.Command = "savescar_uploadFile 1"
		CPanel:AddControl("Button", uploadButton)
	end	
	
	local checkBox = {}
	checkBox.Label = "Try to keep physics"
	checkBox.Description = "parenting with physics or not"
	checkBox.Command = "savescar_restorePhysics"
	CPanel:AddControl("CheckBox", checkBox)

end

function TOOL:StringToNumber( value )

	local something = 1
	something = value
	something = something * 2
	something = something /2
		
	return something
end