local ConVars = {}

// T-REX
ConVars["sk_trex_health"] = 2000
ConVars["sk_trex_dmg_bite"] = 28
ConVars["sk_trex_dmg_swipe"] = 16
ConVars["sk_trex_dmg_headbutt"] = 18
ConVars["sk_trex_dmg_stomp"] = 34
ConVars["sk_trex_dmg_eat"] = 42

for k, v in pairs(ConVars) do
	CreateConVar(k, v, {})
end