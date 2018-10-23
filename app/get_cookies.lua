return function(request)
	local t={}
	for content in string.gmatch(request,"Cookie: (.-)\r\n") do 
		for k,v in content do
			t[k]=v end
		end
	return t
end
