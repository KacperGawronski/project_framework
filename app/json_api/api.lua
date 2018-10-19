
return function(s)
	local function sqlize(str)
		return str:gsub("'","''")
	end
	local t={}
	local limit=30
	local data_table="employee"
	for local k,v in s:gmatch("(%w+)=(%w+)") do
		if k=="limit" then
			local tmp
			assert(tmp=tonumber(v))
			limit=(tmp and tmp<30) or 30
		elseif k=="data_table" then
			data_table=sqlize(v)
		else
			t[sqlize(k)]=sqlize(v)
		end
	end
	print(limit,data_table)
	local fields="*"
	for k,v in t do
		fields=(fields=="*" and k) or fields..","..k
	end
	SELECT = string.format("SELECT %s FROM %s WHERE TRUE",fields,data_table)
	for k,v in t do
		SELECT=SELECT.." AND "..k.."='"..v.."'"
	end
	return SELECT.."LIMIT %s;":format(limit)
	
end
