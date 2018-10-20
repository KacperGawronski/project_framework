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
	
	local GET_value,n=string.gsub(http_request,"GET (.+) HTTP/1%.1.*","%1")
	local request_OK="HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nConnection: close\r\n\r\n"
	local mt={}
	local options={}
	options.g={}
	
	options.g["/"]=function ()
		local f=dofile("app/pages/index.lua")
		coroutine.yield(request_OK)
		if f then for s in f do
			coroutine.yield(s)
		end end	
	end
	
	options.g.page= function()
		local s,n=string.gsub(GET_value,"/page%?(.+)","%1")
		if n>0 then
			coroutine.yield(request_OK)
			local f=dofile("app/pages/"..s..".lua")
			if f then for s in f do
				coroutine.yield(s)
			end end
		end
	end
	
	options.g["api.json"]=function()	
		local s,n=string.gsub(GET_value,"/api%.json%?(.+)","%1")
		if n>0 then
			coroutine.yield(request_OK)
			dofile("app/json_api/api.lua")
			local tmp=mariadb_execute_select(SELECT(s))
			if tmp then coroutine.yield(tmp) end
		end
	end
	
	options.g["js"]=function ()
		local s,n=string.gsub(GET_value,"/(.+)%.js","app/javascript/%1.js")
		if n>0 then
			coroutine.yield(request_OK)
			coroutine.yield(get_js_file(s))
		end
	end
	
	
	options.g["css"]=function ()
		local s,n=string.gsub(GET_value,"/(.+)%.css","app/css/%1.css")
		if n>0 then
			coroutine.yield(request_OK)
			coroutine.yield(get_css_file(s))
		end
	end

	
	options.mt={}
	options.mt.__index=function (t,v)
		local filetype,n=string.gsub(v,".*%.(%w+).*","%1")
		if n>0 and (filetype=="css" or filetype=="js") then
			return options[filetype]
		end
		local v=v:gsub("/(.*)%?.*","%1")
		if not v then v="/" end
		return options.g[v]
	end
	setmetatable(options,options.mt)

	return(options[GET_value])

end


--[[ UGLY VERSION

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
						s,n=string.gsub(GET_value,"/page%?(.+)","%1")
						if n>0 then
							local f=dofile("app/pages/"..s..".lua")
							if f then for s in f do
								coroutine.yield(s)
							end end
						else
							if GET_value=="/" then
								local f=dofile("app/pages/index.lua")
								if f then for s in f do
									coroutine.yield(s)
								end end
							end
						end
					end
				end
			end
		end
	end
	return main
end
--]]
