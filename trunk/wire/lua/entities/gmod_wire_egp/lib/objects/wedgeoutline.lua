-- Author: Divran
local Obj = EGP:NewObject( "WedgeOutline" )
Obj.angle = 0
Obj.size = 45
Obj.Draw = function( self )
	if (self.a>0 and self.w > 0 and self.h > 0 and self.size != 360) then
		local vertices = {}
		
		vertices[1] = { x = self.x, y = self.y }
		local ang = -math.rad(self.angle)
		local c = math.cos(ang)
		local s = math.sin(ang)
		for ii=0,180 do
			local i = ii*(360-self.size)/180
			local rad = math.rad(i)
			local x = math.cos(rad)
			local y = math.sin(rad)
			local tempx = x * self.w * c - y * self.h * s + self.x
			y = x * self.w * s + y * self.h * c + self.y
			x = tempx
			
			vertices[#vertices+1] = { x = x, y = y }
		end
		
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		local n = #vertices
		for k,v in ipairs( vertices ) do
			if (k+1 == n) then break end
			local x, y = v.x, v.y
			local x2, y2 = vertices[k+1].x, vertices[k+1].y
			surface.DrawLine( x, y, x2, y2 )
		end
		surface.DrawLine( vertices[n].x, vertices[n].y, vertices[1].x, vertices[1].y )
	end
end
Obj.Transmit = function( self )
	EGP.umsg.Short( (self.angle%360)*20 )
	EGP.umsg.Short( (self.size%360)*20 )
	self.BaseClass.Transmit( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.angle = um:ReadShort()/20
	tbl.size = um:ReadShort()/20
	table.Merge( tbl, self.BaseClass.Receive( self, um ) )
	return tbl
end
Obj.DataStreamInfo = function( self )
	local tbl = {}
	table.Merge( tbl, self.BaseClass.DataStreamInfo( self ) )
	table.Merge( tbl, { angle = self.angle, size = self.size } )
	return tbl
end