
function SELECT(s)
	local t={}
	local limit=30
	local data_table="employees"
	print(s)
	s=string.gsub(s,"'","''"):gsub("%3E",">"):gsub("%3C","<")
	for k,sign,v in s:gmatch("([%w_,]+)([<=>]+)([%w_,]+)") do
		if k=="limit" then
			local tmp
			tmp=tonumber(v)
			if tmp<30 then limit=tmp else limit=30 end
		elseif k=="data_table" then
			data_table=v
		else
			t[k]={sign,v}
		end
	end
	local fields="*"
	for k,v in pairs(t) do
		if fields=="*" then fields=k else fields=fields..k end
	end

	local SELECT = string.format("SELECT %s FROM %s WHERE TRUE ",fields,data_table)
	
	for k,v in pairs(t) do
		SELECT=SELECT.."AND "..k..v[1].."'"..v[2].."' "
	end
	SELECT=SELECT..string.format("LIMIT %d",limit)
	print(SELECT)
	return SELECT
	
end
