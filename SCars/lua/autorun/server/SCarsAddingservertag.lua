
--Credit goes to the makers of Wire mod

local tags = string.Explode(",",(GetConVarString("sv_tags") or ""))
for i,tag in ipairs(tags) do
	if tag:find("SCars") or tag:find("SCars 1.2") or tag:find("SCars 2.0") then table.remove(tags,i) end	
end
table.insert(tags, "SCars 1.4")
table.sort(tags)
RunConsoleCommand("sv_tags", table.concat(tags, ","))
