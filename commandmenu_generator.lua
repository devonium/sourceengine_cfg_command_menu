local ExtendedMenu = false 
local args = {...}

if args[2] == "-extended"
then
	ExtendedMenu = true
end

-- yeah im lazy asf
if ExtendedMenu 
then

	local filename = args[1]

	if not filename 
	then 
		error("no file provided")
	end

	local file = io.open(filename, "rb")
	if not file then error("file does not exist") end
	file:close()

	local l = [[
alias bindmenu_restore_19 "bind 1 slot1;bind 2 slot2;bind 3 slot3;bind 4 slot4;bind 5 slot5;bind 7 slot7;bind 8 slot8;bind 9 slot9"
alias bindmenu_override_46 "bind 7 bindmenu_prev;bind 8 bindmenu_next; bind 9 bindmenu_close;"

alias bindmenu_bindopenkey "" 
alias bindmenu_bindclosekey "" 

alias bindmenu_printpage "clear;con_filter_enable 0;wait 5;bindmenu_slot1;bindmenu_slot2;bindmenu_slot3;bindmenu_slot4;bindmenu_slot5;bindmenu_slot6;bindmenu_slot7;bindmenu_slot8;bindmenu_slot9;wait 5;con_filter_enable 1;"
alias bindmenu_open "bindmenu_bindclosekey;wait 25; bindmenu_override_46;developer 1;con_notifytime 10000;bindmenu_page1"
alias bindmenu_close "bindmenu_bindopenkey;developer 0;con_filter_enable 0;con_notifytime 8;bindmenu_restore_19"
alias bindmenu_next ""
alias bindmenu_prev ""

alias bindmenu_slot1 echo "1.EMPTY"
alias bindmenu_slot2 echo "2.EMPTY"
alias bindmenu_slot3 echo "3.EMPTY"
alias bindmenu_slot4 echo "4.EMPTY"
alias bindmenu_slot5 echo "5.EMPTY"
alias bindmenu_slot6 echo "6.EMPTY"
alias bindmenu_slot7 echo "7.PREV"
alias bindmenu_slot8 echo "8.NEXT"
alias bindmenu_slot9 echo "9.EXIT"

con_filter_text 0
con_filter_text_out 0
contimes 25
]]

	local lines = {}

	for line in io.lines(filename) 
	do
		if line:match("%[KEY:")
		then
			local key = line:match("%[KEY:[%s]*([^%]%s]*)")
			l = l .. 'alias bindmenu_bindopenkey "bind '.. key ..' bindmenu_open"\n'
			.. 'alias bindmenu_bindclosekey "bind '.. key ..' bindmenu_close"\n'
		else
			local name, cmd = line:match("%[(.*)]"), line:match("%[.*][%s]?(.*)")
			lines[#lines + 1] = {name,cmd}
		end
	end

	local line_ind = 1
	local lines_count = #lines

	local page_ind = 1
	local page_count = math.ceil(lines_count / 5)

	while line_ind <= lines_count
	do
		l = l .. "\n\n//////PAGE " .. page_ind.. "\n"
		local bindmenu_page = 'alias bindmenu_page' .. page_ind .. ' "'
		for i = 1, 5
		do
			local name = (line_ind <= lines_count) and (lines[line_ind][1]) or ("EMPTY")
			local cmd = (line_ind <= lines_count) and (lines[line_ind][2]) or ("")

			l = l .. 'alias bindmenu_page' .. page_ind .. '_slot' .. i .. ' echo'..'"' .. i .. "." .. name:gsub(" ", ".") .. '"\n'
			l = l .. 'alias bindmenu_page' .. page_ind .. '_say' .. i .. '"bindmenu_close;' .. cmd .. '"\n\n'
			bindmenu_page = bindmenu_page .. 'alias bindmenu_slot' .. i ..  ' bindmenu_page' .. page_ind .. '_slot' .. i ..";" 
			bindmenu_page = bindmenu_page .. 'bind ' .. i .. ' ' .. 'bindmenu_page' .. page_ind .. '_say' .. i ..";"
			line_ind = line_ind + 1
		end
		
		
		l = l .. 'alias bindmenu_page' .. page_ind .. '_prev ' .. ((page_ind == 1) and ('""') or ('bindmenu_page' .. (page_ind - 1))) .. '\n'
		l = l .. 'alias bindmenu_page' .. page_ind .. '_next ' .. ((line_ind <= lines_count) and ('bindmenu_page' .. (page_ind + 1)) or ('""')) .. '\n'
		
		l = l .. bindmenu_page .. 'alias bindmenu_next' ..	' bindmenu_page'.. page_ind .. '_next ' .. ';alias bindmenu_prev' ..' bindmenu_page'.. page_ind .. '_prev ' .. ';alias bindmenu_slot9 echo "9.EXIT.[' .. page_ind .. '/' .. page_count .. ']"' .. ';bindmenu_printpage"\n' 

		page_ind = page_ind + 1
	end


	l = l .. "bindmenu_bindopenkey\n"

	local file = io.open("cmdmenu" .. ".cfg", "wb")
	file:write(l)
	file:close()

else
	local filename = args[1]

	if not filename 
	then 
		error("file not provided")
	end

	local file = io.open(filename, "rb")
	if not file then error("file does not exist") end
	file:close()

	local l = [[
alias bindmenu_restore_06 "bind 1 slot1;bind 2 slot2;bind 3 slot3;bind 4 slot4;bind 5 slot5;bind 6 slot6;"
alias bindmenu_override_46 "bind 4 bindmenu_prev;bind 5 bindmenu_next; bind 6 bindmenu_close;"

alias bindmenu_bindopenkey "" 
alias bindmenu_bindclosekey "" 

alias bindmenu_printpage "clear;con_filter_enable 0;wait 5;bindmenu_slot1;bindmenu_slot2;bindmenu_slot3;bindmenu_slot4;bindmenu_slot5;bindmenu_slot6;wait 5;con_filter_enable 1;"
alias bindmenu_open "bindmenu_bindclosekey;wait 25; bindmenu_override_46;developer 1;con_notifytime 10000;bindmenu_page1"
alias bindmenu_close "bindmenu_bindopenkey;developer 0;con_filter_enable 0;con_notifytime 8;bindmenu_restore_06"
alias bindmenu_next ""
alias bindmenu_prev ""

alias bindmenu_slot1 echo "1.EMPTY"
alias bindmenu_slot2 echo "2.EMPTY"
alias bindmenu_slot3 echo "3.EMPTY"
alias bindmenu_slot4 echo "4.PREV"
alias bindmenu_slot5 echo "5.NEXT"
alias bindmenu_slot6 echo "6.EXIT"

con_filter_text 0
con_filter_text_out 0
]]

	local lines = {}

	for line in io.lines(filename) 
	do
		if line:match("%[KEY:")
		then
			local key = line:match("%[KEY:[%s]*([^%]%s]*)")
			l = l .. 'alias bindmenu_bindopenkey "bind '.. key ..' bindmenu_open"\n'
			.. 'alias bindmenu_bindclosekey "bind '.. key ..' bindmenu_close"\n'
		else
			local name, cmd = line:match("%[(.*)]"), line:match("%[.*][%s]?(.*)")
			lines[#lines + 1] = {name,cmd}
		end
	end

	local line_ind = 1
	local lines_count = #lines

	local page_ind = 1
	local page_count = math.ceil(lines_count / 3)

	while line_ind <= lines_count
	do
		l = l .. "\n\n//////PAGE " .. page_ind.. "\n"
		local bindmenu_page = 'alias bindmenu_page' .. page_ind .. ' "'
		for i = 1, 3
		do
			local name = (line_ind <= lines_count) and (lines[line_ind][1]) or ("EMPTY")
			local cmd = (line_ind <= lines_count) and (lines[line_ind][2]) or ("")

			l = l .. 'alias bindmenu_page' .. page_ind .. '_slot' .. i .. ' echo'..'"' .. i .. "." .. name:gsub(" ", ".") .. '"\n'
			l = l .. 'alias bindmenu_page' .. page_ind .. '_say' .. i .. '"bindmenu_close;' .. cmd .. '"\n\n'
			bindmenu_page = bindmenu_page .. 'alias bindmenu_slot' .. i ..  ' bindmenu_page' .. page_ind .. '_slot' .. i ..";" 
			bindmenu_page = bindmenu_page .. 'bind ' .. i .. ' ' .. 'bindmenu_page' .. page_ind .. '_say' .. i ..";"
			line_ind = line_ind + 1
		end
		
		
		l = l .. 'alias bindmenu_page' .. page_ind .. '_prev ' .. ((page_ind == 1) and ('""') or ('bindmenu_page' .. (page_ind - 1))) .. '\n'
		l = l .. 'alias bindmenu_page' .. page_ind .. '_next ' .. ((line_ind <= lines_count) and ('bindmenu_page' .. (page_ind + 1)) or ('""')) .. '\n'
		
		l = l .. bindmenu_page .. 'alias bindmenu_next' ..	' bindmenu_page'.. page_ind .. '_next ' .. ';alias bindmenu_prev' ..' bindmenu_page'.. page_ind .. '_prev ' .. ';alias bindmenu_slot6 echo "6.EXIT.[' .. page_ind .. '/' .. page_count .. ']"' .. ';bindmenu_printpage"\n' 

		page_ind = page_ind + 1
	end


	l = l .. "bindmenu_bindopenkey\n"

	local file = io.open("cmdmenu" .. ".cfg", "wb")
	file:write(l)
	file:close()
end