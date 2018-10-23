return function(request)
	local t={}
	for k,v in string.gmatch("Cookie: (.*)=(.)\r\n") do t[k]=v end
	return t
end
