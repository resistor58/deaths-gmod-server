//Execute script client-side
if (CLIENT) then

local function PlayMusicMenu( Panel )

		local params = {}
		params.Text = "Stop all Music"
		params.Description = "Stops all sounds from playing"
		params.Command = "playsound stop"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Half-Life 1 Soundtrack]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Half-Life 1 - ''Black Mesa Inbound''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL1_song3.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Unforeseen consequences''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL1_song5.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Tunnels''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL1_song6.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - Song 9"
		params.Description = "[Atmopshere]"
		params.Command = "playsound music/HL1_song9.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Helicopter chase''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL1_song10.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Valve theme''"
		params.Description = "[Valve]"
		params.Command = "playsound music/HL1_song11.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - Song 14"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL1_song14.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Lighthouse Stand''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL1_song15.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Heavy Machinery''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL1_song17.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Sustainability''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL1_song19.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''Black Mesa East''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL1_song20.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - Song 21"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL1_song21.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - Song 24"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL1_song24.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 1 - ''End Credits Mix''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL1_song25_REMIX3.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Half-Life 1 - ''Cascade Resonance''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL1_song26.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Half-Life 2 Soundtrack]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "''Radio''"
		params.Description = "[Special]"
		params.Command = "playsound music/radio1.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "''Ravenholm''"
		params.Description = "[Special]"
		params.Command = "playsound music/Ravenholm_1.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Intro Song"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_intro.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Citadel''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_song0.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 1"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song1.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 2"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song2.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Highway 17''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song3.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 4"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song4.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Strider''"
		params.Description = "[Special]"
		params.Command = "playsound music/HL2_song6.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Ravenholm''"
		params.Description = "[Stinger]"
		params.Command = "playsound music/HL2_song7.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 8"
		params.Description = "[Special]"
		params.Command = "playsound music/HL2_song8.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Kleiner's lab''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song10.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Disrepair''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_song11.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 12"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song12_long.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 13"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_song13.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Water Hazard"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song14.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''The Nexus''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song15.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Follow Freeman''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song16.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 17"
		params.Description = "[Stinger]"
		params.Command = "playsound music/HL2_song17.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Nova Prospekt''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song19.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 20 Submix"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song20_submix0.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 20 Submix 4"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song20_submix4.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Gunship Down''"
		params.Description = "[Stinger]"
		params.Command = "playsound music/HL2_song23_SuitSong3.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Combine Theme''"
		params.Description = "[Stinger]"
		params.Command = "playsound music/HL2_song25_Teleporter.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Hardly ideal conditions''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song26.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Welcome to City 17''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_song26_trainstation1.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Sight of Citadel''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song27_trainstation2.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 28"
		params.Description = "[Stinger]"
		params.Command = "playsound music/HL2_song28.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - ''Head to Route Canal''"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song29.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 30"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_song30.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 31"
		params.Description = "[Action]"
		params.Command = "playsound music/HL2_song31.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 32"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/HL2_song32.mp3"
		Panel:AddControl( "Button",params)
		
		local params = {}
		params.Text = "Half-Life 2 - Song 33"
		params.Description = "[Ambience]"
		params.Command = "playsound music/HL2_song33.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Episode One Soundtrack]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Episode 1 - ''Eine Kleiner Elevatormuzik''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/VLVX_song1.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Combine Advisory''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/VLVX_song2.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Guard Down''"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song4.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Darkness at Noon''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/VLVX_song8.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Disrupted Original''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song11.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Self-Destruction''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song12.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''What kind of Hospital is this''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song18.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Infraradiant''"
		params.Description = "[Atmopshere]"
		params.Command = "playsound music/VLVX_song19a.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Decay Mode''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/VLVX_song19b.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 1 - ''Penultimatum''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song21.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Episode Two Soundtrack]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Episode 2 - ''No One Rides For Free''"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song0.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Dark Interval''"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song3.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - Song 9"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song9.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Nectarium''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/VLVX_song15.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Extinction Event Horizon''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/VLVX_song20.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Vortal Combat''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song22.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Sector Sweep''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song23.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Shu'ulathoi''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/VLVX_song23ambient.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Last Legs''"
		params.Description = "[Action]"
		params.Command = "playsound music/VLVX_song24.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Abandoned In Place''"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song25.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Inhuman Frequency''"
		params.Description = "[Ambience]"
		params.Command = "playsound music/VLVX_song26.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Hunting Party''"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song27.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Episode 2 - ''Eon Trap''"
		params.Description = "[Special]"
		params.Command = "playsound music/VLVX_song28.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "[Portal Soundtrack]"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Portal - ''Subject Name Here''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_subject_name_here.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Taste of Blood''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_taste_of_blood.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Android Hell''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_android_hell.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Self-Esteem Fund''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_self_esteem_fund.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Procedural Jiggle Bone''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_procedural_jiggle_bone.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''No Cake For You''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_no_cake_for_you.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''4000 Degrees Kelvin''"
		params.Description = "[Action]"
		params.Command = "playsound music/portal_4000_degrees_kelvin.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Stop What You Are Doing''"
		params.Description = "[Special]"
		params.Command = "playsound music/portal_stop_what_you_are_doing.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Party Escort''"
		params.Description = "[Atmosphere]"
		params.Command = "playsound music/portal_party_escort.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Your Not a Good Person''"
		params.Description = "[Special]"
		params.Command = "playsound music/portal_youre_not_a_good_person.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''You Can't Escape You Know''"
		params.Description = "[Action]"
		params.Command = "playsound music/portal_you_cant_escape_you_know.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "Portal - ''Still Alive''"
		params.Description = "[GLaDOS v0.97]"
		params.Command = "playsound music/portal_still_alive.mp3"
		Panel:AddControl( "Button",params)

		local params = {}
		params.Text = "------------------------------------------------------------------"
		params.Description = ""
		Panel:AddControl( "Label",params)

		local params = {}
		params.Text = "Stop all Music"
		params.Description = "Stops all sounds from playing"
		params.Command = "playsound stop"
		Panel:AddControl( "Button",params)

end


local function NewMenu()
	spawnmenu.AddToolMenuOption("Options", "Sounds", "Music Menu", "Music Options", "", "", PlayMusicMenu)
end
hook.Add( "PopulateToolMenu", "PlayMusicMenu", NewMenu )

end

//Add script server-side
if SERVER then
AddCSLuaFile("autorun/playmusicselect.lua")
end