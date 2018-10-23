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



local function f(cookies)
	local process_template=dofile("app/page_template.lua")
	local page_structure={}
	page_structure.title="Example use of json api."
	page_structure.script="<script src=\"example.js\"></script>"
	page_structure.body=function ()
		local function f()
			coroutine.yield("<div id=\"main\">\
<form action=\"javascript:get_val_from_request()\">\
Limit</br><input id=\"limit\">\
</input></form>\
<div id=\"example\"></div></div>")
		end
		return coroutine.wrap(function () f() end)
	end
	
	for txt in process_template(page_structure) do
		coroutine.yield(txt)
	end
end

return function (args) return coroutine.wrap(function () f(args) end) end
