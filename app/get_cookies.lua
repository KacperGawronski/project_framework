return function(request)
	local t={}
	for k,v in string.gmatch(request,"Cookie: (.*)=(.)\r\n") do t[k]=v end
	return t
end
