
function SELECT(s)
	local t={}
	local limit=1000
	local data_table="employees"
	local fields="*"
	s=string.gsub(s,"'","''"):gsub("%%3E",">"):gsub("%%3C","<")
	for k,sign,v in s:gmatch("([%w_,]+)([<=>]+)([%w_,]+)") do
		if k=="limit" then
			local tmp
			tmp=tonumber(v)
			if tmp<1000 then limit=tmp else limit=1000 end
		elseif k=="data_table" then
			data_table=v
		elseif k=="fields" then
			if fields=="*" then fields=v else fields=fields..v end
		else
			t[k]={sign,v}
		end
	end
	for k,v in pairs(t) do
	end

	local SELECT = string.format("SELECT %s FROM %s WHERE TRUE ",fields,data_table)
	
	for k,v in pairs(t) do
		SELECT=SELECT.."AND "..k..v[1].."'"..v[2].."' "
	end
	SELECT=SELECT..string.format("LIMIT %d",limit)
	return SELECT
	
end
