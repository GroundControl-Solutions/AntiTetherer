-- --------------------------------------------------------------
--
-- AntiTetherer
--
-- Mac app to prevent iOS devices from creating new network interfaces
-- 
-- Originally by GroundControl Solutions Inc.
-- 
-- Only useful on macOS 10.12.5 and above, with iOS 10.3 and above
--
-- Installation: this AppleScript was designed to be run within an Automator
-- app. Launch Automator and create a new App. Add the "Run Applescript"
-- action to the workflow, and paste in this script.
-- 
-- --------------------------------------------------------------

-- file

set serviceName to "com.GroundControl.DisableAppleUSBNCM"
set launchdFile to "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>GroupName</key>
    <string>wheel</string>
    <key>KeepAlive</key>
    <false/>
    <key>Label</key>
    <string>" & serviceName & "</string>
    <key>ProgramArguments</key>
    <array>
        <string>/sbin/kextunload</string>
        <string>/System/Library/Extensions/AppleUSBNCM.kext</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>root</string>
</dict>
</plist>
"

----------------------
-- Installation
----------------------

-- test if LaunchDaemon already exists
set launchdPlist to "/Library/LaunchDaemons/" & serviceName & ".plist"

-- See if we've already loaded the LaunchDaemon
tell application "System Events" to set launchdFileExists to file launchdPlist exists

if launchdFileExists is false then
	
	display dialog "Would you like to install the iOS Device Hider? After installation you can decide if you want to show or hide iOS devices in the network preference pane." buttons {"Quit", "Install"} cancel button "Quit" default button "Install" with icon note
	
	-- create the file but make sure it is disabled
	do shell script "sudo echo " & quoted form of launchdFile & " >> " & launchdPlist with administrator privileges
	do shell script "sudo launchctl disable system/" & serviceName with administrator privileges
	
end if

----------------------
-- Are we Enabled?
----------------------

do shell script "launchctl print-disabled system | grep " & serviceName & " | grep true | wc -l"
set isEnabled to the (result as number) > 0

if isEnabled then
	
	display dialog "iOS devices are SHOWING in the Network Pref pane." buttons {"Hide", "Keep Showing"} default button 2 with icon note
	if the button returned of the result is "Hide" then
		do shell script "sudo launchctl enable system/" & serviceName with administrator privileges
		do shell script "sudo kextload /System/Library/Extensions/AppleUSBNCM.kext" with administrator privileges
	end if
	
else
	
	display dialog "iOS devices are currently HIDDEN from the Network Pref pane." buttons {"Keep Hiding", "Show"} default button 1 with icon note
	
	if the button returned of the result is "Show" then
		do shell script "sudo launchctl disable system/" & serviceName with administrator privileges
		do shell script "sudo kextunload /System/Library/Extensions/AppleUSBNCM.kext" with administrator privileges
	end if
	
end if

