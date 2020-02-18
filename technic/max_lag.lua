local function explode(sep, input)
        local t={}
        local i=0
        for k in string.gmatch(input,"([^"..sep.."]+)") do
            t[i]=k
            i=i+1
        end
        return t
end

function technic.get_max_lag()
	local arrayoutput = explode(", ",minetest.get_server_status())
	local arrayoutput2 = explode("=",arrayoutput[4])
	return tonumber(arrayoutput2[1])
end
