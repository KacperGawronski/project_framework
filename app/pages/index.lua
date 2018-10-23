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
	page_structure.title="Example index for framework"
	page_structure.script=""
	page_structure.body=function ()
		local function g()
			coroutine.yield("<div id=\"main\"><h2>Welcome to open example Project Framework based on Lua_WebServer and Example Lua App</h2></br>")
			coroutine.yield("You can find them on github:</br>\
<a href=\"https://github.com/KacperGawronski/Lua_Webserver\">Lua_Webserver</a></br>\
<a href=\"https://github.com/KacperGawronski/example_Lua_app\">example_Lua_app</a></br>")
			coroutine.yield("Both are licensed under GNU General Public License v3</br>\
			Project Framework, also licensed on GNU GPL v3, can be found on:</br>\
			<a href=\"https://github.com/KacperGawronski/project_framework\">https://github.com/KacperGawronski/project_framework</a></div>")
		end
		return coroutine.wrap(function () g() end)
	end
	
	for txt in process_template(page_structure) do
		coroutine.yield(txt)
	end
end

return function(args) return coroutine.wrap(function () f(args) end) end
