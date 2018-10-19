--[[
Author: Kacper Gawroński

This file is part of Project Framework.

Project Framework is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Project Framework is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Project Framework. If not, see
https://www.gnu.org/licenses/
--]]



function generate_head(t)
	local f,err=io.open("app/css/requires.txt","r")
	local txt
	if not err then txt=f:read("*all")
	io.close(f)
	else
		return "error"
	end
	return string.format("<head><title>%s</title>%s %s</head>",t.title,t.script,txt)
end
