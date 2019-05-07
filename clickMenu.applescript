use AppleScript version "2.4" -- Yosemite (10.10) or later
use alfLib : script "Alfred Library"

on run argv
	tell application "Script Debugger" to activate
	set wf to alfLib's newWorkflow()
	
	if class of argv = script then
		set argv to "Alfred - add_result.txt"
		set varArg to "/Applications/Script Debugger.app/Contents/ApplicationSupport/Clippings/AppleScriptObjC"
		set thePath to "/Users/kevinfunderburg/Library/Application Support/Script Debugger 7/Clippings/Apps/Alfred - add_result.txt"
	else
		set argv to item 1 of argv
		set thePath to wf's getVar("thePath")
		log "thePath is: " & thePath
	end if
	
	log "argv is: " & argv
	if argv contains ".txt" then set argv to wf's SearchandReplace(argv, ".txt", "")
	if argv contains ")" then set argv to characters 4 thru end of argv as text
	log "argv is: " & argv
	
	if thePath contains "Library" then
		set menuItems to wf's SearchandReplace(thePath, "/Users/kevinfunderburg/Dropbox/Library/Application Support/Script Debugger 7/Clippings", "")
	else
		set menuItems to wf's SearchandReplace(thePath, "/Applications/Script Debugger.app/Contents/ApplicationSupport/Clippings", "")
	end if
	if menuItems contains "/" then set menuItems to wf's q_split(menuItems, "/")
	
	tell application "System Events"
		tell process "Script Debugger"
			set theMenu to first menu of (first menu bar item of menu bar 1 whose name is "Clippings")
			
			if class of menuItems = text then
				tell theMenu
					try
						set theMenuItem to (first menu item whose name is argv)
						click theMenuItem
					on error errMsg
						log errMsg
					end try
				end tell
			else
				repeat with n from 1 to (count of items of menuItems) - 1
					if item n of menuItems is not "" then
						tell theMenu
							try
								set theMenuItem to (first menu item whose name is item n of menuItems)
							on error errMsg
								log errMsg
							end try
						end tell
						
						set theMenu to menu 1 of theMenuItem
					end if
				end repeat
				
				tell theMenu
					try
						set theMenuItem to (first menu item whose name is argv)
						click theMenuItem
					on error errMsg
						log errMsg
					end try
				end tell
				
			end if
			
		end tell
	end tell
end run
---——————————————————————————————————————————————-

on recursiveClick(theMenu, menuItem)
	tell application "System Events"
		tell process "Script Debugger"
			try
				set m to first menu item of theMenu whose name is menuItem
			on error errMsg number errNum
				set theMenu to first menu item of theMenu whose (help is missing value and title is not "")
				recursiveClick(theMenu, menuItem)
			end try
		end tell
	end tell
end recursiveClick
