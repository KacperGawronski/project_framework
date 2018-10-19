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



local function f()
	local process_template=dofile("app/page_template.lua")
	local page_structure={}
	page_structure.title="Example index for framework"
	page_structure.script="<script src=\"example.js\"></script>"
	page_structure.body=function ()
		local function f()
			coroutine.yield("<div id=\"example\"></div>")
		end
		return coroutine.wrap(function () f() end)
	end
	
	for txt in process_template(page_structure) do
		coroutine.yield(txt)
	end
end

return coroutine.wrap(function () f() end)
