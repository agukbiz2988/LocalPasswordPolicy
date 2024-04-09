
#Error Message for incorrect Number
$incorrectNum = "`nSorry thats an incorrect input required for this function`n"
   
function passwordComplexity{
    param(
        [Int] $num
    )

    secedit.exe /export /cfg C:\secconfig.cfg
    Start-Sleep 1

    switch($num){
        0{
            #Disable Complexity
            (Get-Content -path C:\secconfig.cfg -Raw) -replace 'PasswordComplexity = 1', 'PasswordComplexity = 0' | Out-File -FilePath C:\secconfig.cfg
            Start-Sleep 1
        }
        1{
            #Enable Complexity
            (Get-Content -path C:\secconfig.cfg -Raw) -replace 'PasswordComplexity = 0', 'PasswordComplexity = 1' | Out-File -FilePath C:\secconfig.cfg
            Start-Sleep 1
        }
        default{Write-Host $incorrectNum}
    }

    secedit.exe /configure /db $env:windir\securitynew.sdb /cfg C:\secconfig.cfg /areas SECURITYPOLICY
}

function adminLockout{
    param(
        [Int] $num
    )

    secedit.exe /export /cfg C:\secconfig.cfg
    Start-Sleep 1

    switch($num){
        0{
            #Disable Admin Lockout
            (Get-Content -path C:\secconfig.cfg -Raw) -replace 'AllowAdministratorLockout = 1', 'AllowAdministratorLockout = 0' | Out-File -FilePath C:\secconfig.cfg
            Start-Sleep 1
        }
        1{
            #Enable Admin Lockout
            (Get-Content -path C:\secconfig.cfg -Raw) -replace 'AllowAdministratorLockout = 0', 'AllowAdministratorLockout = 1' | Out-File -FilePath C:\secconfig.cfg
            Start-Sleep 1
        }
        default{Write-Host $incorrectNum}
    }

    secedit.exe /configure /db $env:windir\securitynew.sdb /cfg C:\secconfig.cfg /areas SECURITYPOLICY
}

function choosePolicy{
    param(
        [Int]$policy,
        [Int]$num
    )

    switch($policy){
        1{ Net Accounts /MINPWLEN:$num         }
        2{ Net Accounts /MINPWAGE:$num         }
        3{ Net Accounts /MAXPWAGE:$num         }
        4{ Net Accounts /UNIQUEPW:$num         }
        5{ Net accounts /lockoutthreshold:$num }
        6{ Net Accounts /lockoutduration:$num  }
        7{ Net Accounts /lockoutwindow:$num    }
    }
}

function createAdmin {

    Write-Host "Please Enter an Admin Account Username"
    $accountName = Read-Host
    Write-Host "Please Enter Password for the New Account"
    $password = Read-Host -AsSecureString
   
    New-LocalUser -name $accountName -password $password -PasswordNeverExpires 
    Add-LocalGroupMember -Group Administrators -Member $accountName
}

function menu{
    $menuLoop = $true

    while($menuLoop){
        
        $menuChoice = Read-Host "`n
        Welcome to the Password Policy Script

        Please choose one of the following options:
            
            [0] See Current Password Policy
            [1] Change Minimum Password Length
            [2] Change Minimum Password Age
            [3] Change Maximum Password Age
            [4] Change Password History Size
            [5] Change Lockout Threshold
            [6] Change Lockout Duration Time
            [7] Change Lockout Window Time
            [8] Enable/Disable Password Complexity
            [9] Enable/Disable Administrator Account Lockout

        Other options:

            [A] Create a Local Admin Account
            [D] Set Default Password Policy
            [R] Set Recommended Password Policy (Most Secure)

        Exit

            [E] Exit
        `n"


        switch($menuChoice){
            0{ net accounts }
            1{
                $num = Read-Host "Please Enter The Minimum Password Length"
                choosePolicy(1)($num)
             }
            2{  
                $num = Read-Host "Please Enter The Minimum Password Age"
                choosePolicy(2)($num)        
             }
            3{ 
                $num = Read-Host "Please Enter The Maximum Password Age"
                choosePolicy(3)($num)       
             }
            4{ 
                $num = Read-Host "Please Enter The Password History Size"
                choosePolicy(4)($num)       
             }
            5{ 
                $num = Read-Host "Please Enter Lockout Attempts Threshold"
                choosePolicy(5)($num)       
             }
            6{ 
                $num = Read-Host "Please Enter Lockout Duration Time"
                choosePolicy(6)($num)       
             }
            7{ 
                $num = Read-Host "Please Enter Lockout Window Time"
                choosePolicy(7)($num)
             }
            8{ 
                $num = Read-Host "`n
        Please Choose one of the Following Options For Password Complexity

            [0] Disable Password Complexity 
            [1] Enable Password Complexity
            [E] Exit
                `n"

                passwordComplexity($num)
             }
            9{ 
                $num = Read-Host "`n
        Please Choose one of the Following Options For Admin Lockout

            [0] Disable Admin Lockout 
            [1] Enable Admin Lockout
            [E] Exit
                `n"

                adminLockout($num)
             }
            A{
                createAdmin
            }
            D{
                #Enable/Disable Password Complexity
                Write-Host "Turning Complexity Off " -ForegroundColor green
                passwordComplexity(0)
                Write-Host "Complextity Turned off`n" -ForegroundColor green
                Start-Sleep 1

                #Enable/Disable Administrator Account Lockout
                Write-Host "Disabling Admin Lockout" -ForegroundColor green
                adminLockout(0)
                Write-Host "Completed Disabling Admin Lockout`n" -ForegroundColor green
                Start-Sleep 1

                #Change Minimum Password Length
                Write-Host "Changing Minimum Password Length Back to Default" -ForegroundColor green
                choosePolicy(1)(0)
                Start-Sleep 1

                #Change Minimum Password Age
                Write-Host "Changing Minimum Password Age Back to Default" -ForegroundColor green
                choosePolicy(2)(0)
                Start-Sleep 1

                #Change Maximum Password Age
                Write-Host "Changing Maximum Password Age Back to Default" -ForegroundColor green
                choosePolicy(3)(42)
                Start-Sleep 1

                #Change Password History Size
                Write-Host "Changing Password History Size Back to Default" -ForegroundColor green
                choosePolicy(4)(0)
                Start-Sleep 1

                #Change Lockout Threshold
                Write-Host "Changing Lockout Threshold Back to Default" -ForegroundColor green
                choosePolicy(5)(10)
                Start-Sleep 1

                #Change Lockout Duration Time
                Write-Host "Changing Lockout Duration Time Back to Default" -ForegroundColor green
                choosePolicy(7)(10)
                Start-Sleep 1

                #Change Lockout Window Time
                Write-Host "Changing Lockout Window Time Back to Default" -ForegroundColor green
                choosePolicy(6)(10)
                Start-Sleep 1

                net accounts
            }
            R{
                #Enable/Disable Password Complexity
                Write-Host "Turning Complexity On " -ForegroundColor green
                passwordComplexity(1)
                Write-Host "Complextity Turned On`n" -ForegroundColor green
                Start-Sleep 1

                #Enable/Disable Administrator Account Lockout
                Write-Host "Enabling Admin Lockout" -ForegroundColor green
                adminLockout(1)
                Write-Host "Completed Enabling Admin Lockout`n" -ForegroundColor green
                Start-Sleep 1

                #Change Minimum Password Length
                Write-Host "Changing Minimum Password Length to Recommended Setting" -ForegroundColor green
                choosePolicy(1)(12)
                Start-Sleep 1

                #Change Minimum Password Age
                Write-Host "Changing Minimum Password Age to Recommended Setting" -ForegroundColor green
                choosePolicy(2)(0)
                Start-Sleep 1

                #Change Maximum Password Age
                Write-Host "Changing Maximum Password Age to Recommended Setting" -ForegroundColor green
                choosePolicy(3)(182)
                Start-Sleep 1

                #Change Password History Size
                Write-Host "Changing Password History Size to Recommended Setting" -ForegroundColor green
                choosePolicy(4)(24)
                Start-Sleep 1

                #Change Lockout Threshold
                Write-Host "Changing Lockout Threshold to Recommended Setting" -ForegroundColor green
                choosePolicy(5)(5)
                Start-Sleep 1

                #Change Lockout Window Time
                Write-Host "Changing Lockout Window Time to Recommended Setting" -ForegroundColor green
                choosePolicy(6)(30)
                Start-Sleep 1

                #Change Lockout Duration Time
                Write-Host "Changing Lockout Duration Time to Recommended Setting" -ForegroundColor green
                choosePolicy(7)(30)
                Start-Sleep 1

                net accounts
            }
            E{
                Write-Host "`nThank you for using this Password Policy Script`n"
                $menuLoop = $false
            }
            default{incorrectNum}
        }
    }
}

menu
