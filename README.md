# KIMMO MOVIEMAKER 🎥

```
Welcome to
____________________________________________                                         
    _    _     __   _   _    _   _      __                                           
    /  ,'      /    /  /|    /  /|    /    )                                         
---/_.'-------/----/| /-|---/| /-|---/----/-                                         
  /  \       /    / |/  |  / |/  |  /    /                                           
_/____\___ _/_ __/__/___|_/__/___|_(____/___                                         
                                                                                     
                                                                                     
_____________________________________________________________________________________
    _   _      __   _    _     __   _____    _   _    __     _    _   _____    ____  
    /  /|    /    ) |   /      /    /    '   /  /|    / |    /  ,'    /    '   /    )
---/| /-|---/----/--|--/------/----/__------/| /-|---/__|---/_.'-----/__------/___ /-
  / |/  |  /    /   | /      /    /        / |/  |  /   |  /  \     /        /    |  
_/__/___|_(____/____|/____ _/_ __/____ ___/__/___|_/____|_/____\___/____ ___/_____|__
```

Powershell and ffmpeg glue for concatenating videos. Created for situations where you want to simply cut parts of bunch of videos and concatenate them to a new single video.

## Usage

Drag the source videos into the kimmomoviemaker shortcut in File Explorer and follow instructions.

![](screenshot.png)

## Install

* Install Powershell
* Install ffmpeg


After that, create a new shortcut in file explorer which has target set as `powershell.exe -File "C:\Path To Your\kimmo-moviemaker\concat.ps1`. After that, dragging files into it is possible and they will be passed as arguments to the powershell script.


## Useful links

* https://stackoverflow.com/questions/45004159/ffmpeg-ss-and-t-for-cutting-mp3
* https://stackoverflow.com/questions/7333232/how-to-concatenate-two-mp4-files-using-ffmpeg
* https://superuser.com/questions/106360/how-to-enable-execution-of-powershell-scripts
* http://ffmpeg.org/download.html
 
