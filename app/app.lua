--[[This file is part of Example Lua App.

Example Lua App is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Example Lua App is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Example Lua App. If not, see
https://www.gnu.org/licenses/
--]]


dofile("app/index.lua")
dofile("app/menu.lua")
dofile("app/head.lua")
dofile("app/javascript/js.lua")
dofile("app/css/css.lua")

function process_request(http_request)
	local main=  function ()
		local GET_value,n=string.gsub(http_request,"GET (.-) HTTP/1%.1.*","%1")
		if n> 0 then
			coroutine.yield("HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nConnection: keep-alive\r\n\r\n")
			if GET_value=="/" then
				coroutine.yield("<html>")
				coroutine.yield(generate_head())
				coroutine.yield("<body><h1 id=\"header\">Example project</h1>")
				coroutine.yield("<div id=\"menu\">")
				coroutine.yield(generate_menu())
				coroutine.yield("</div><div id=\"main\">")
				coroutine.yield(generate_index())
				
				local tmp=mariadb_execute_select("SELECT * FROM employees LIMITS 10")
				coroutine.yield("<table>")
				for _,i in pairs(tmp) do
					coroutine.yield("<tr>")
					for _,j in pairs(i)do
						coroutine.yield("<td>"..j.."</td>")
					end
					coroutine.yield("<tr>")
				end
				coroutine.yield("</table>")
				
				
				coroutine.yield("</div>")
				coroutine.yield("</body></html>")
			else
				local s,n=string.gsub("/api.json%?(.+)")
				if n>0 then
				
				else
					s,n=string.gsub(GET_value,"/(.+)%.js","app/javascript/%1.js")
					if n>0 then coroutine.yield(get_js_file(s))
					else
						s,n=string.gsub(GET_value,"/(.+)%.css","app/css/%1.css")
						if n>0 then coroutine.yield(get_css_file(s)) end
					end
				end
			end
		end
	end
	return main
end
