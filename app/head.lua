function generate_head()
	local f,err=io.open("app/css/requires.txt","r")
	local txt
	if not err then txt=f:read("*all")
	io.close(f)
	else
		return "error"
	end
	return "<head><title>Example Lua App</title>"..txt.."</head>"
end
