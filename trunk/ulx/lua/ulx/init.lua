if not ulx then
	ulx = {}
	
	local sv_modules = file.FindInLua( "ulx/modules/*.lua" )
	local sh_modules = file.FindInLua( "ulx/modules/sh/*.lua" )
	local cl_modules = file.FindInLua( "ulx/modules/cl/*.lua" )

	Msg( "///////////////////////////////\n" )
	Msg( "//       ULX Admin Mod       //\n" )
	Msg( "///////////////////////////////\n" )
	Msg( "// Loading...                //\n" )

	Msg( "//  sh_defines.lua           //\n" )
	include( "sh_defines.lua" )
	Msg( "//  lib.lua                  //\n" )
	include( "lib.lua" )	
	Msg( "//  base.lua                 //\n" )
	include( "base.lua" )
	Msg( "//  log.lua                  //\n" )
	include( "log.lua" )
	
	for _, file in ipairs( sv_modules ) do
		Msg( "//  MODULE: " .. file .. string.rep( " ", 17 - file:len() ) .. "//\n" )
		include( "modules/" .. file )
	end
	
	for _, file in ipairs( sh_modules ) do
		Msg( "//  MODULE: " .. file .. string.rep( " ", 17 - file:len() ) .. "//\n" )
		include( "modules/sh/" .. file )
	end	
	
	Msg( "//  end.lua                  //\n" )
	include( "end.lua" )
	Msg( "// Load Complete!            //\n" )
	Msg( "///////////////////////////////\n" )

	AddCSLuaFile( "ulx/cl_init.lua" )	
	AddCSLuaFile( "ulx/sh_defines.lua" )
	AddCSLuaFile( "ulx/cl_lib.lua" )
	
	-- Find c-side modules and load them
	for _, file in ipairs( cl_modules ) do
		AddCSLuaFile( "ulx/modules/cl/" .. file )
	end
	
	for _, file in ipairs( sh_modules ) do
		AddCSLuaFile( "ulx/modules/sh/" .. file )
	end
end
