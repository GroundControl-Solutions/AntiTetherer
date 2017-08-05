# AntiTetherer
Mac app to prevent iOS devices from creating new network interfaces

Originally by GroundControl Solutions Inc.

## Requirements
Only useful on macOS 10.12.5 and above, with iOS 10.3 and above

## Installation
This AppleScript was designed to run within an Automator app. Launch Automator and create a new App. Add the "Run Applescript" action to the workflow, and paste in this script.

## What does it do?
Recent updates bring tethered caching to macOS, so that iPhones and iPads connected by USB can use the Mac's network connection, instead of the mobile device's. (More info: https://support.apple.com/en-us/HT207523)

One side effect is that every connected iOS device creates a new network interface in the Mac's network preference pane. After a few devices, the network preference pane begins to fill up.

![tethering](https://user-images.githubusercontent.com/219574/28996662-d5c1e5d4-79d2-11e7-92de-ab6b58644c3d.png)

If you are logged into the Mac as a normal, non-admin user, you'll see a dialog about a "New Network Interface" every time you connect a device.

![net-network](https://user-images.githubusercontent.com/219574/28996657-cd688762-79d2-11e7-8e63-c4bf5eba772b.png)

If you are running an operation that provisions dozens or hundreds of devices each day, these constant dialogs can be a problem. 

The AntiTetherer prevents the Mac from creating these network interfaces. It does this by unloading the Mac kernel extension responsible for networking over USB.

    sudo kextload /System/Library/Extensions/AppleUSBNCM.kext

Because the kernel extension will load again at reboot, AntiTetherer will also place a LaunchDaemon in /Library/LaunchDaemons. This way the Mac will remember your preference to Show or Hide devices.

## Operation
The first time you run the app, it will prompt you to install the LaunchDaemon. This allows AntiTetherer to run at startup.

<img width="532" alt="install" src="https://user-images.githubusercontent.com/219574/28996789-8da44380-79d4-11e7-81d5-d19f6ddae4ad.png">

If you install, the app will prompt for an admin username and password.

Once installed, the app will display the current status, and prompt you to change the status. By default, the Mac will SHOW connected iOS devices.

<img width="532" alt="showing" src="https://user-images.githubusercontent.com/219574/28996775-4ac58dda-79d4-11e7-971a-74059e71f3c7.png">

If you opt to hide connected devices (that's the point of this app after all), the dialog will show the following:

<img width="532" alt="hiding" src="https://user-images.githubusercontent.com/219574/28996778-56beedf2-79d4-11e7-8e50-5b41623de618.png">

## Uninstallation
To fully uninstall, delete the LaunchDaemon with the following terminal command:
    sudo rm /Library/LaunchDaemons/com.GroundControl.DisableAppleUSBNCM.plist
Then reboot your Mac.
