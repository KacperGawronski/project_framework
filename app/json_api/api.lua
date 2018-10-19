
function SELECT(s)
	s=string.gsub(s,".*(').*","''")
	local t={}
	local limit=30
	local data_table="employee"
	for k,v in s:gmatch("(%w+)=(%w+)") do
		if k=="limit" then
			local tmp
			tmp=tonumber(v)
			if tmp<30 then limit=tmp else limit=30 end
		elseif k=="data_table" then
			data_table=sqlize(v)
		else
			t[sqlize(k)]=sqlize(v)
		end
	end
	print(limit,data_table)
	local fields="*"
	for k,v in pairs(t) do
		if fields=="*" then fields=k else fields=fields..k end
	end

	SELECT = string.format("SELECT %s FROM %s WHERE TRUE ",fields,data_table)
	
	for k,v in pairs(t) do
		SELECT=SELECT.."AND "..k.."='"..v.."' "
	end
	return SELECT..string.format("LIMIT %d;",limit)
	
end
