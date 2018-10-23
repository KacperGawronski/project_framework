return function(request)
	local t={}
	if request then
		for content in string.gmatch(request,"Cookie: (.-)\r\n") do 
			for k,v in string.gmatch(content,"(%w+)=(%w+)") do
				t[k]=v end
			end
		end
	end
	return t
end
