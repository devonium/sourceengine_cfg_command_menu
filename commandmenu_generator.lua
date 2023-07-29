local ExtendedMenu = false 
local args = {...}

if args[2] == "-extended"
then
	ExtendedMenu = true
end

-- yeah im lazy asf

local menuLinesCount = ExtendedMenu and 5 or 3

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
]] ..
(ExtendedMenu and ([[alias bindmenu_override_46 "bind 6 bindmenu_prev;bind 7 bindmenu_next; bind 8 bindmenu_close;"]]) or ([[alias bindmenu_override_46 "bind 4 bindmenu_prev;bind 5 bindmenu_next; bind 6 bindmenu_close;"]])) ..
[[

alias bindmenu_bindopenkey "" 
alias bindmenu_bindclosekey "" 
alias bindmenu_currentpage bindmenu_page1
]] ..
(ExtendedMenu and ([[alias bindmenu_printpage "clear;con_filter_enable 0;wait 5;bindmenu_slot1;bindmenu_slot2;bindmenu_slot3;bindmenu_slot4;bindmenu_slot5;bindmenu_slot6;bindmenu_slot7;bindmenu_slot8;wait 5;con_filter_enable 1;"]]) or ([[alias bindmenu_printpage "clear;con_filter_enable 0;wait 5;bindmenu_slot1;bindmenu_slot2;bindmenu_slot3;bindmenu_slot4;bindmenu_slot5;bindmenu_slot6;wait 5;con_filter_enable 1;""]])) ..
[[

alias bindmenu_open "bindmenu_bindclosekey;wait 25; bindmenu_override_46;developer 1;con_notifytime 10000;bindmenu_page1"
alias bindmenu_reopen "wait 1;bindmenu_bindclosekey;wait 25; bindmenu_override_46;developer 1;con_notifytime 10000;bindmenu_currentpage"
alias bindmenu_updatepage "bindmenu_currentpage"
alias bindmenu_close "bindmenu_bindopenkey;developer 0;con_filter_enable 0;con_notifytime 8;bindmenu_restore_19"
alias bindmenu_next ""
alias bindmenu_prev ""
]] ..

(ExtendedMenu and 
[[
alias bindmenu_slot1 echo "1.EMPTY"
alias bindmenu_slot2 echo "2.EMPTY"
alias bindmenu_slot3 echo "3.EMPTY"
alias bindmenu_slot4 echo "4.EMPTY"
alias bindmenu_slot5 echo "5.EMPTY"
alias bindmenu_slot6 echo "6.PREV"
alias bindmenu_slot7 echo "7.NEXT"
alias bindmenu_slot8 echo "8.EXIT"

]]
or
[[
alias bindmenu_slot1 echo "1.EMPTY"
alias bindmenu_slot2 echo "2.EMPTY"
alias bindmenu_slot3 echo "3.EMPTY"
alias bindmenu_slot4 echo "4.PREV"
alias bindmenu_slot5 echo "5.NEXT"
alias bindmenu_slot6 echo "6.EXIT"
]])
..
[[

con_filter_text 0
con_filter_text_out 0
contimes 25
]]

local lines = {}

local header = ""

local cfgMode = false
local postCfg = ""

for line in io.lines(filename) 
do
	header = header .. "//" .. line .. "\n"
	if line:match("%[KEY:")
	then
		local key = line:match("%[KEY:[%s]*([^%]%s]*)")
		l = l .. 'alias bindmenu_bindopenkey "bind '.. key ..' bindmenu_open"\n'
		.. 'alias bindmenu_bindclosekey "bind '.. key ..' bindmenu_close"\n'
	elseif line:match("%[CFG%]")
	then
		cfgMode = true
	elseif line:match("%[CMD%]")
	then
		cfgMode = false
	else
		if cfgMode
		then
			line = line:gsub("{CURRCMD_PAGE}", math.ceil(#lines / menuLinesCount))
			line = line:gsub("{CURRCMD_SLOT}", #lines % (menuLinesCount+1))
			line = line:gsub("{CURRCMD_NAME}", #lines % (menuLinesCount+1) .. '.' .. (lines[#lines])[1]:gsub(" ", "."))
			postCfg = postCfg .. line .. "\n"
		else
			local name, cmd = line:match("%[(.*)]"), line:match("%[.*][%s]?(.*)")
			if name and cmd
			then
				lines[#lines + 1] = {name,cmd}
			end
		end
	end
end



l = "////// SOURCE BEG //////\n" .. header .. "////// SOURCE END //////\n\n" .. l

local line_ind = 1
local lines_count = #lines

local page_ind = 1
local page_count = math.ceil(lines_count / menuLinesCount)

while line_ind <= lines_count
do
	l = l .. "\n\n////// PAGE " .. page_ind.. " //////\n"
	local bindmenu_page = 'alias bindmenu_page' .. page_ind .. ' "alias bindmenu_currentpage' .. ' bindmenu_page'.. page_ind .. ';'
	for i = 1, menuLinesCount
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
	
	l = l .. bindmenu_page .. "bindmenu_page".. page_ind .. '_setup;' .. ';alias bindmenu_slot'..(ExtendedMenu and 8 or 6)..' echo "'..(ExtendedMenu and 8 or 6)..'.EXIT.[' .. page_ind .. '/' .. page_count .. ']"' .. ';bindmenu_printpage"\n' 
	l = l .. "alias bindmenu_page".. page_ind .. '_setup "' .. 'alias bindmenu_next' ..	' bindmenu_page'.. page_ind .. '_next ' .. ';alias bindmenu_prev' ..' bindmenu_page'.. page_ind .. '_prev ' .. '"'
	page_ind = page_ind + 1
end


l = l .. "\nbindmenu_bindopenkey\n"
l = l .. "\n////// CFG //////\n" .. postCfg
local file = io.open("cmdmenu" .. ".cfg", "wb")
file:write(l)
file:close()

