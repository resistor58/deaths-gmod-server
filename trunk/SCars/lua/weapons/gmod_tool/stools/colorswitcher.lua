//I do not take any credit for this stool.
//Mihara is the author.
//I just changed some simple things so it will fit with my addon

TOOL.Category   = "Sakarias88 Cars"
TOOL.Name       = "#Paint Job Switcher"
TOOL.Command    = nil
TOOL.ConfigName = nil

TOOL.ClientConVar[ "skin" ] 		= 0


if ( SERVER ) then

local manualcontrol = true
local oldslider = 0
local newslider = 0

end

if ( CLIENT ) then 

local colorswitcherPreviousEntity = nil

language.Add("Tool_colorswitcher_name", "Paint Job Switcher")
language.Add("Tool_colorswitcher_desc", "Changes the paint job on the car.")
language.Add("Tool_colorswitcher_0", "Left click to cycle paint job. \nRight click to select a car for manipulation.\nReload to pick a random paint job.")

function TOOL.BuildCPanel( CPanel, SwitchEntity )
  -- HEADER
  CPanel:AddControl( "Header", { Text = "#Tool_colorswitcher_name", 
                                 Description	= "#Tool_colorswitcher_desc" 
                               }  )
                               
  if ValidEntity(SwitchEntity) then
    local maxskins = SwitchEntity:SkinCount()
    if maxskins > 1 then
      CPanel:AddControl("Slider", { Label = "Select Paint Job", 
                                    Description = "Number of paint jobs the car has.", 
                                    Type = "Integer", 
                                    Min = 0, 
                                    Max = maxskins-1, 
                                    Command = "colorswitcher_skin" 
                                  } )
    else
      CPanel:AddControl("Label", { Text = "This car only has one paint job." } )
    end
  else
    CPanel:AddControl("Label", { Text = "No car selected." } )
  end
end

function TOOL:RebuildControlPanel()
  local CPanel = GetControlPanel( "colorswitcher" )
  if ( !CPanel ) then return end
  CPanel:ClearControls()
  self.BuildCPanel(CPanel, self:GetcolorswitcherEntity())
end


function TOOL:DrawHUD()

  local selected = self:GetcolorswitcherEntity()
		
  if ( !ValidEntity( selected ) ) then return end
	
		local scrpos = selected:GetPos():ToScreen()
		if (!scrpos.visible) then return end
		
		local player_eyes = LocalPlayer():EyeAngles()
		local side = (selected:GetPos() + player_eyes:Right() * 50):ToScreen()
		local size = math.abs( side.x - scrpos.x )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture(surface.GetTextureID( "gui/faceposer_indicator"))
		surface.DrawTexturedRect( scrpos.x-size, scrpos.y-size, size*2, size*2 )

end


end -- if CLIENT

function TOOL:GetcolorswitcherEntity()
	return self:GetWeapon():GetNetworkedEntity( 1 )
end

function TOOL:SetcolorswitcherEntity( ent )
	return self:GetWeapon():SetNetworkedEntity( 1, ent )
end



function TOOL:LeftClick(Trace)

	if not(string.find( Trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( Trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( Trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or Trace.Entity.IsDestroyed == 1 then return false end 

  if not Trace.Entity:IsValid() then
    return false
  end

  if ( CLIENT ) then return true end

  local skins = Trace.Entity:SkinCount()

  
  if skins <= 1 then
    return false
  else 
    local currentskin = Trace.Entity:GetSkin()
    local newskin = 0
    if (currentskin + 1) >= skins then
      newskin = currentskin + 1 - skins
    else
      newskin = currentskin+1
    end  
    Trace.Entity:SetSkin(newskin)
	Trace.Entity:EmitSound("carStools/spray.wav",80,math.random(100,150))
  end

  return true

end

function TOOL:Reload(Trace)

	if not(string.find( Trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( Trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( Trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or Trace.Entity.IsDestroyed == 1 then return false end 

  if not Trace.Entity:IsValid() then
    return false
  end

  if ( CLIENT ) then return true end

  local skins = Trace.Entity:SkinCount()
	
  if skins == 1 then
    return false
  else 
    local currentskin = Trace.Entity:GetSkin()
    local newskin = currentskin
    while newskin == currentskin do
      newskin = math.random(skins)
    end
	Trace.Entity:EmitSound("carStools/spray.wav",80,math.random(100,150))	
    Trace.Entity:SetSkin(newskin)
  end

  return true
    
end

function TOOL:RightClick(Trace)

	if not(string.find( Trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( Trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( Trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or Trace.Entity.IsDestroyed == 1 then return false end 


  if Trace.Entity:IsValid() then
    if ( CLIENT ) then return true end 
    self.SelectedEntity = Trace.Entity
    self:SetcolorswitcherEntity(self.SelectedEntity)
  else
    self.SelectedEntity = nil
    return false
  end
end

function TOOL:Think()
  if ( CLIENT ) then
    if not (colorswitcherPreviousEntity == self:GetcolorswitcherEntity()) then
      self:RebuildControlPanel()
      colorswitcherPreviousEntity = self:GetcolorswitcherEntity()
    end
    return
  end

  newslider = self:GetClientNumber("skin")
  if newslider ~= oldslider then
    oldslider = newslider
    manualcontrol = false
  else
    manualcontrol = true
  end

  if self.SelectedEntity then 
    if self.SelectedEntity:IsValid() then
      if self.SelectedEntity:SkinCount() > 1 then
        -- I can't say it's good code, but I'm fed up with it.
        if not manualcontrol then
          self.SelectedEntity:SetSkin(newslider)
        end
      end
    end
  end 
end
