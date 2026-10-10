# Run in PowerShell:  powershell -ExecutionPolicy Bypass -File .\run_all.ps1
$CLASS = "Anom_Thread"

javac "$CLASS.java"
if ($LASTEXITCODE -ne 0) { Write-Host "Compile failed"; exit 1 }

New-Item -ItemType Directory -Force -Path outputs | Out-Null
$inc = @{ 1=1000; 2=10000; 5=10000; 10=50000; 20=50000; 50=50000; 100=50000 }
$res = "outputs/results.csv"
"threads,increments,mode,run,expected,static,nonstatic,absdiff,pct" | Out-File $res -Encoding ascii

function Get-Val($text, $label) {
    $line = ($text | Select-String -SimpleMatch $label | Select-Object -First 1).Line
    return (($line -split ":")[1]).Trim()
}

foreach ($n in 1,2,5,10,20,50,100) {
    $m = $inc[$n]
    $runs = @( @("true",1), @("false",1), @("false",2), @("false",3), @("false",4), @("false",5) )
    foreach ($r in $runs) {
        $mode = $r[0]; $run = $r[1]
        Write-Host "Threads=$n Increments=$m Mode=$mode Run=$run"
        $out = java $CLASS $n $m $mode
        $out | Out-File "outputs/T${n}_${mode}_run${run}.txt" -Encoding ascii
        $exp = Get-Val $out "Expected count"
        $st  = Get-Val $out "Static count"
        $ns  = Get-Val $out "Non-static total"
        $ad  = Get-Val $out "Absolute diff"
        $pc  = Get-Val $out "Difference"
        "$n,$m,$mode,$run,$exp,$st,$ns,$ad,$pc" | Out-File $res -Append -Encoding ascii
    }
}
Write-Host "Done. See outputs/results.csv"
