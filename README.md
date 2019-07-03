# Sir Ocelot (Early Alpha)

![SOFM Main Window](https://repository-images.githubusercontent.com/163692156/a0ea9f80-9dd0-11e9-93dd-7d76ca5e608c)

Sir Ocelot File Manager (SOFM) is a file manager with the capabilities to use and store several panels (that is, more than the standard 2) at once, allowing the user to quickly switch between multiple locations and logical groups of tabs. And also it has a pretty UI, I think.

Features:
* The left and the right panel stacks may hold any amount of panels within them, only one panel per stack may be shown at any time.

  A panel may hold any amount of tabs within itself, it may be added to favorites by pressing the "star" button and later brought up when creating new panels.  
  
  New panels can be created by pressing the "+" button on a stack's current panel. A stack's panels can be selected or removed from its list by pressing the "triple dash" button.  
  
  Both of the stack's current panels may be minimized at the same time and added to the app's paired panels list and brought up later.
* Basic file manipulation (create, delete, copy, move, etc.)
* Ability to select multiple files
* Basic drag'n'drop handling of objects between panels, from and to external sources.
* Ability to sort view contents by columns
* Basic search functionality by using wildcards or regex, able to set the depth as well.
* The menu bar and the quick access bar contain shortcuts to various actions that can be executed.

***
[Click here to download v0.3.0](https://github.com/M-Zimmer/Sir-Ocelot/releases/tag/0.3.0)

To deploy the app yourself follow these steps:
> 1. Install the MSVC2017/MSVC2017_64 build of [Qt](https://www.qt.io/download).
> 2. Build the executable file either from [Qt Creator](https://doc.qt.io/qtcreator/creator-build-example-application.html) or [the             command line](https://doc.qt.io/qt-5/qmake-running.html).
> 3. Execute deploy_MSVC2017.cmd for the 32 bit version or deploy_MSVC2017_64.cmd for the 64 bit version, the first argument should be the executable file's path and name ("C:\\SirOcelot.exe", for example).  
> **Note: You may omit this parameter if the .exe file is in the same folder as the batch script (and the source code!).**
> 4. (Optional) You may also specify a second parameter which should be a path to the qtenv2.bat script that sets up the environment and is located in <Qt_folder>/<version_number>/(msvc2017 or msvc2017_64)/bin. Otherwise, the script will attempt to find the necessary path itself.

Once the script has finished, the full application should be located in <project_path>/(build32 or build64)

*Qt 5.12.3*  
*Created by Max "ZiMMeR_7" Mazur*  
*Licensed under the LGPLv3 license, the license file is included with the application.*  
*© Max Mazur 2018-2019*
