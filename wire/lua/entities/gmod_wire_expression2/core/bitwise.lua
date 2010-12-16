--   By asiekierka,  2009   --
--Non-luabit XOR by TomyLobo--

__e2setcost(2)

e2function number bAnd(a, b)
	return (a & b)
end
e2function number bOr(a, b)
	return (a | b)
end
e2function number bXor(a, b)
	return (a | b) & (-1-(a & b))
end
e2function number bShr(a, b)
	return a >> b
end
e2function number bShl(a, b)
	return a << b
end
e2function number bNot(n)
	return (-1)-n
end
e2function number bNot(n,bits)
	if bits >= 32 || bits < 1 then
		return (-1)-n
	else
		return (math.pow(2,bits)-1)-n
	end
end

__e2setcost(nil)