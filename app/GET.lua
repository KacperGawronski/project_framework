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


dofile("app/javascript/js.lua")
dofile("app/css/css.lua")

function process_request(http_request)
	local main=  function ()
		local GET_value,n=string.gsub(http_request,"GET (.+) HTTP/1%.1.*","%1")
		if n>0 then
			coroutine.yield("HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nConnection: close\r\n\r\n")
			local s,n=string.gsub(GET_value,"/api%.json%?(.+)","%1")
			if n>0 then
				dofile("app/json_api/api.lua")
				local tmp=mariadb_execute_select(SELECT(s))
				if tmp then coroutine.yield(tmp) end
			else
				s,n=string.gsub(GET_value,"/(.+)%.js","app/javascript/%1.js")
				if n>0 then coroutine.yield(get_js_file(s))
				else
					s,n=string.gsub(GET_value,"/(.+)%.css","app/css/%1.css")
					if n>0 then coroutine.yield(get_css_file(s))
					else
						s,n=string.gsub(GET_value,"/page?(.+)")
						if n>0 then
							local f=dofile("app/pages/"..s..".lua")
							for s in f do
								coroutine.yield(s)
							end
						else
							if GET_value=="/" then
								local f=dofile("app/pages/index.lua")
								for s in f do
									coroutine.yield(s)
								end
							end
						end
					end
				end
			end
		end
	end
	return main
end
