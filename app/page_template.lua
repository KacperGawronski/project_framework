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


dofile("app/menu.lua")
dofile("app/head.lua")
local function f(t)

	coroutine.yield("<!DOCTYPE html>\
<html><body>\n")
	coroutine.yield(generate_head(t))
	if generate_menu then coroutine.yield(generate_menu())
	for txt in t.body() do
		coroutine.yield(txt)
	end
	coroutine.yield("</body></html>")
end

return function(t) return coroutine.wrap(function () f(t) end) end
