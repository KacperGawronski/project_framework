function get_css_file(path)
	f,err=io.open(path,"r")
	if not err then
		return f:read("*all")
	else
		return ""
	end
end
