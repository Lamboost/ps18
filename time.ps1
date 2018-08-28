#Lamboost
#7-Dig Time
$x = "█"
function dig {
    param([bool]$tm,[bool]$tl,[bool]$tr,[bool]$mm,[bool]$bl,[bool]$br,[bool]$bm)
    [array]$dig    
    $dig = 
    $($(if($tm -or $tl){$x}else{" "})+$(if($tm){$x}else{" "})+$(if($tm -or $tr){$x}else{" "})),
    $($(if($tl){$x}else{" "})+" "+$(if($tr){$x}else{" "})),
    $($(if($tl -or $mm -or $bl){$x}else{" "})+$(if($mm){$x}else{" "})+$(if($tr -or $mm -or $br){$x}else{" "})),
    $($(if($bl){$x}else{" "})+" "+$(if($br){$x}else{" "})),
    $($(if($bl -or $bm){$x}else{" "})+$(if($bm){$x}else{" "})+$(if($br -or $bm){$x}else{" "}));
    return $dig
}
function zahl {
    param([int]$zahl)    
        switch($zahl){
            0{  $nr= dig 1 1 1 0 1 1 1   }
            1{  $nr= dig 0 0 1 0 0 1 0   }
            2{  $nr= dig 1 0 1 1 1 0 1   }
            3{  $nr= dig 1 0 1 1 0 1 1   }
            4{  $nr= dig 0 1 1 1 0 1 0   }
            5{  $nr= dig 1 1 0 1 0 1 1   }
            6{  $nr= dig 1 1 0 1 1 1 1   }
            7{  $nr= dig 1 0 1 0 0 1 0   }
            8{  $nr= dig 1 1 1 1 1 1 1   }
            9{  $nr= dig 1 1 1 1 0 1 1   }
        }
        return $nr  
}
[array]$dp = "   ",$(" "+$x+" "),"   ",$(" "+$x+" "),"   "
$max=60*60*24*365*25
for ($t=0; $t -le $max; $t++){
    $time = Get-Date -Format HH.mm.ss
    [string]$h,[string]$m,[string]$s = $time.Split(".")
    $t1 = zahl $h.substring(0,1)
    $t2 = zahl $h.substring(1,1)
    $t3 = zahl $m.substring(0,1)
    $t4 = zahl $m.substring(1,1)
    $t5 = zahl $s.substring(0,1)
    $t6 = zahl $s.substring(1,1)
    Write-Host -- $t1[1] $t2[1]$dp[0]$t3[1] $t4[1]$dp[0]$t5[1] $t6[1]
    Write-Host -- $t1[2] $t2[2]$dp[1]$t3[2] $t4[2]$dp[1]$t5[2] $t6[2]
    Write-Host -- $t1[3] $t2[3]$dp[2]$t3[3] $t4[3]$dp[2]$t5[3] $t6[3]
    Write-Host -- $t1[4] $t2[4]$dp[3]$t3[4] $t4[4]$dp[3]$t5[4] $t6[4]
    Write-Host -- $t1[5] $t2[5]$dp[4]$t3[5] $t4[5]$dp[4]$t5[5] $t6[5]
    start-sleep -Milliseconds 990
    cls
}
