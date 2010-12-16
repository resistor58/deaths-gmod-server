//Execute script client-side
if (CLIENT) then

local function PlayOverwatchMenu( Panel )

		local params = {}
		params.Text = "Halt all announcements"
		params.Description = "Stops all sounds from playing"
		params.Command = "playsound stop"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Structural malfunction announcements]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Perimeter restrictors disengaged"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_restrictorsdisengaged.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Unrest structure detected"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_localunrest_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Surveillance and detection systems inactive"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_detectionsystemsout.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Malignant interface bypass detected"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_interfacebypass.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Confiscation field failure"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_confiscationfailure.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Contact lost in block"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_deployinb4.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Civil miscompliance announcements]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Anticitizen reported in this community"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Illegal counter-resonant device detected"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_deploy.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Unregistered weapons detected"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_confiscating.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Non-standard exogen activity detected"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_nonstandardexogen.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "This block contains civil infection"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_trainstation_inform_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Anticivil activity in this community"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Status evasion in progress"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Your block is charged with inactive coersion"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Miscount detected in your block"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_trainstation_cooperation_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Critical exogen breach"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_airwatchdispatched.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Community orders announcements]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Inaction is conspiracy"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Assemble for identification check"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Assume inspection positions"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Confirm civil status"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Unrest procedure code now in effect"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Sentencing is now discretionary"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Capital prosecution is now discretionary"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Evasion behaviour reminder"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_evasionbehavior_2_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Cooperation failure reminder"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Mission failure reminder"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fprison_missionfailurereminder.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Invididual sentencing announcements]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Social endangerment"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_ceaseevasionlevelfive_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Heavy social endangerment"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Anticivil activity"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_anticivil1_5_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Capital malcompliance"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Multiple anticivil violations"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Singularity warnings]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Singularity sequence engaged"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_transportsequence.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "3 Minutes"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_3minutestosingularity.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "2 Minutes"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_2minutestosingularity.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "1 Minute"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_1minutetosingularity.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "45 Seconds"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_45sectosingularity.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "30 Seconds"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_30sectosingularity.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "15 Seconds"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_15sectosingularity.wav"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "10 Seconds"
		params.Description = ""
		params.Command = "playsound npc/overwatch/cityvoice/fcitadel_10sectosingularity.wav"
		Panel:AddControl( "Button",params)

end


local function NewMenu()
	spawnmenu.AddToolMenuOption("Options", "Sounds", "Overwatch Menu", "Overwatch", "", "", PlayOverwatchMenu)
end
hook.Add( "PopulateToolMenu", "PlayOverwatchMenu", NewMenu )

end

//Add script server-side
if SERVER then
AddCSLuaFile("autorun/playoverwatchselect.lua")
end