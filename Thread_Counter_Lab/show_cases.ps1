# Usage:  .\show_cases.ps1 4     -> runs TC4 only (both modes), for a screenshot
#         .\show_cases.ps1       -> runs all test cases
param([int]$TC = 0)
$CLASS = "Anom_Thread"
javac "$CLASS.java"
if ($LASTEXITCODE -ne 0) { Write-Host "Compile failed"; exit 1 }
$cases = @( @(1,1,1000), @(2,2,10000), @(3,5,10000), @(4,10,50000), @(5,20,50000), @(6,50,50000), @(7,100,50000) )
foreach ($c in $cases) {
    if ($TC -ne 0 -and $c[0] -ne $TC) { continue }
    foreach ($mode in "true","false") {
        Write-Host ""
        Write-Host "===== TC$($c[0]): java $CLASS $($c[1]) $($c[2]) $mode ====="
        java $CLASS $c[1] $c[2] $mode
    }
}
