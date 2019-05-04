# ffmpeg -i 1.mp4 -i 2.mp4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" output_video.mp4

cd $PSScriptRoot

$files = $args
$filecount = $files.Length

write-host "`n`nWelcome to"
write-host "____________________________________________                                         "
write-host "    _    _     __   _   _    _   _      __                                           "
write-host "    /  ,'      /    /  /|    /  /|    /    )                                         "
write-host "---/_.'-------/----/| /-|---/| /-|---/----/-                                         "
write-host "  /  \       /    / |/  |  / |/  |  /    /                                           "
write-host "_/____\___ _/_ __/__/___|_/__/___|_(____/___                                         "
write-host "                                                                                     "
write-host "                                                                                     "
write-host "_____________________________________________________________________________________"
write-host "    _   _      __   _    _     __   _____    _   _    __     _    _   _____    ____  "
write-host "    /  /|    /    ) |   /      /    /    '   /  /|    / |    /  ,'    /    '   /    )"
write-host "---/| /-|---/----/--|--/------/----/__------/| /-|---/__|---/_.'-----/__------/___ /-"
write-host "  / |/  |  /    /   | /      /    /        / |/  |  /   |  /  \     /        /    |  "
write-host "_/__/___|_(____/____|/____ _/_ __/____ ___/__/___|_/____|_/____\___/____ ___/_____|__"
write-host "                                                                                     "
                                                                                     

if ($filecount -lt 1) {
    write-host "Error: no video files provided"
    read-host -prompt "Press enter to exit"
    exit
}


function print-files {
    $arr = $args[0]
    For ($i = 0; $i -lt $arr.Length; $i++) {
        $filepath = $arr[$i] 
        write-host "[$i]: $filepath"
    }
}

function print-pieces {
    $arr = $args[0]
    write-host "`nThe composition now:"
    ForEach ($piece in $pieces) {
        $filepath = $files[$piece.index]

        $startText = $piece.start
        if ([string]::IsNullOrWhiteSpace($startText)) {
            $startText = "start"
        }

        $endText = $piece.end
        if ([string]::IsNullOrWhiteSpace($endText)) {
            $endText = "end"
        }

        write-host "$startText - $endText  ${filepath}"
    }
    write-host "`n"
}


# All individual video pieces in the composition
$pieces = @()

do {
    $filenum = -1
    while ($filenum -lt 0 -or $filenum -gt ($filecount - 1)) {
        write-host "`nFrom which file do you want to cut from?`n"
        print-files $files
        $filenum = read-host -prompt "`nWrite the file number"
    }
    
    # https://superuser.com/questions/138331/using-ffmpeg-to-cut-up-video
    $start = read-host -prompt "Start time in ffmpeg format [mm:ss] (leave empty for start of the video)"
    $end = read-host -prompt "End time in ffmpeg format [mm:ss] (leave empty for end of the video)"
    $pieces += [PsObject]@{ start=$start; end=$end; index=$filenum }

    print-pieces $pieces
    
    $answer = read-host -prompt "Do you want to add another piece to the composition?`n[y]: select a new video `n[n]: start processing`n`nAnswer (n)"
} while ($answer -eq "y")


write-host "Cutting pieces .."
$tmppieces = @()

For ($i = 0; $i -lt $pieces.Length; $i++) {
    $piece = $pieces[$i]
    $filepath = $files[$piece.index]
    $extension = [System.IO.Path]::GetExtension($filepath)
    $tmpfilename = "_piece${i}${extension}"
  
    $tmppieces += $tmpfilename

    $cutcmd = "ffmpeg -i '$filepath'"
    if (-not [string]::IsNullOrWhiteSpace($piece.start)) {
        $cutcmd += " -ss $($piece.start)"
    } else {
        $cutcmd += " -ss 00:00:00"
    }

    if (-not [string]::IsNullOrWhiteSpace($piece.end)) {
        $cutcmd += " -to $($piece.end)"
    }

    $cutcmd += " '$tmpfilename'"

    write-host $cutcmd
    iex $cutcmd
}

$concatcmd = "ffmpeg"
$filterpart = ""

For ($i = 0; $i -lt $tmppieces.Length; $i++) {
    $filepath = $tmppieces[$i] 
    $concatcmd += " -i '$filepath'" 
    $filterpart += "[${i}:v] [${i}:a] "
}

$piecescount = $tmppieces.Length
$extension = [System.IO.Path]::GetExtension($tmppieces[0])
$concatcmd += " -filter_complex '$filterpart concat=n=${piecescount}:v=1:a=1 [v] [a]' -map '[v]' -map '[a]' output${extension}"

write-host $concatcmd
iex $concatcmd

ForEach ($tmpfile in $tmppieces) {
    Remove-Item -Path "$tmpfile"
}

write-host "`nVideo written to output${extension}`n"
read-host -prompt "Press enter to exit"
