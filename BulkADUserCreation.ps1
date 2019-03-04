<#
------------------------------------------------------------
Author: John Leger
Date: Feb. 20, 2019
Powershell Version Built/Tested on: 5.1
Title: PowerShell Bulk AD User Creation from CSV
Website: https://github.com/johnbljr
License: GNU General Public License v3.0
------------------------------------------------------------
#>        

# Import AD Module
Import-Module ActiveDirectory

# FilePrep
     # Change this to reflect where your working folder location is.
     $dir = "c:\adcreation"

    # Directory Creation
    # Once the script is used it populates a temp directory. This deletes the entries from that directory
    # and creates a fresh directory for each subsequent use.   
            Remove-Item $dir -Force -Recurse
            New-Item -ItemType Directory -Force -path $dir
        
       <# Creates the temp files that we are going to use for 
       separating the accounts from those usernames that exist 
       from those that do not exist. We will then use these files
       to email out the results.
       #>

       
        # CSV File Import
        $initial = Read-Host -Prompt 'Enter Location and name of csv importfile (ex. c:\temp\userimport.csv)'
        Copy-Item -Path $initial -Destination $dir\Userimport.csv
        $csv = Import-CSV $dir\Userimport.csv
        $adusers = Get-ADuser -Filter * -Properties samAccountName | Select-Object samAccountName

        # Creates a new file with just the users that need to be created in Active Directory
          New-Item -path $dir\notexist.csv 
          Add-Content -path $dir\notexist.csv -value "SAMAccountName,GivenName,Surname,DisplayName,EmailAddress,Title,Department,Office,Description,managerUN,mgrEmail,OfficePhone,helpDeskEmail,technician,Company,coSuffix,StreetAddress,City,State,PostalCode,Country,upnSuffix,password,ou" -passthru

        # Assign Variables to imported CSV File

   foreach ($element in $csv)
    {
     
      # Creates the headers in the temp csv files

      
            $GivenName = $element.GivenName
            $Surname = $element.Surname
            $DisplayName = $element.DisplayName
            $SAMAccountName = $element.samaccountname
            $EmailAddress = $element.Email
            $Title = $element.Title
            $Department = $element.Department
            $Office = $element.Office
            $Description = $element.Description
            $managerUN = $element.managerUN
            $mgrEmail = $element.mgremail
            $OfficePhone = $element.Officephone
            $helpDeskEmail = $element.helpdeskemail
            $technician = $element.technician
            $Company = $element.Company
            $coSuffix = $element.coSuffix
            $StreetAddress = $element.streetaddress
            $City = $element.city
            $State = $element.state
            $PostalCode = $element.postalcode
            $Country = $element.country
            $upnSuffix = $element.upnSuffix
            $password = $element.password


                       
            
<# Check to see if the user already exists in Active Directory
If it does then the script writes the name to a separate CSV file          
#>
   if($adusers.samaccountname -eq $samaccountname)
      {
     New-Item -Path $dir -name exists_$SamaccountName.csv -Force -Itemtype File 
     Add-Content -Path $dir\exists_$SamaccountName.csv -Value "samaccountname"
     Add-Content -Path $dir\exists_$SamaccountName.csv -value "$samaccountname"

# Email out the details of usernames that already exist 
# Change the below details based on your organization

$To = "ToEmail@domain.com"
$From = "FromEmail@domain.com"
$SMTP = "smtp.domain.com"
$Subject = 'Failed to create new user ' + $Samaccountname + ' in Active Directory'
$Body = 'Username ' + $Samaccountname + ' was not created in Active Directory - This is probably due to the username already being in use. Please verify and resubmit.'
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTP
#Remove-Item -Path $dir\exists_$SamaccountName.csv -Force
       }
            else 
       {
            if($aduser.samaccountname -ne $samaccountname)
            {

          # Create a New CSV file for creating AD users - this removed 
                Add-Content -path $dir\notexist.csv -value "SAMAccountName,GivenName,Surname,DisplayName,EmailAddress,Title,Department,Office,Description,managerUN,mgrEmail,OfficePhone,helpDeskEmail,technician,Company,coSuffix,StreetAddress,City,State,PostalCode,Country,upnSuffix,password,ou" -passthru
                Add-Content -Path $dir\notexist.csv -value "$SAMAccountName,$GivenName,$Surname,$DisplayName,$EmailAddress,$Title,$Department,$Office,$Description,$managerUN,$mgrEmail,$OfficePhone,$helpDeskEmail,$technician,$Company,$coSuffix,$StreetAddress,$City,$State,$PostalCode,$Country,$upnSuffix,$password,$OU" -PassThru

            }
         }
    }     

            # Import New CSV File for the users that we are going to create
            $create = Import-csv $dir\notexist.csv
            
            foreach ($User in $create)
            {  

          # Assign New Variable Based On the New CSV File
          # Enter in the OU destination below
            #$OU = "OU=OUName,DC=DCName,DC=local"
            $SAMAccountNameAD = $user.samaccountname
            $GivenNameAD = $user.GivenName
            $SurnameAD = $user.Surname
            $DisplayNameAD = $user.DisplayName
            $EmailaddressAD = $user.Email
            $TitleAD = $user.Title
            $DepartmentAD = $user.Department
            $OfficeAD = $user.Office
            $DescriptionAD = $user.Description
            $managerUNAD = $user.managerUN
            $OfficePhoneAD = $user.officephone
            $CompAD = $user.Company
            $CoSuffixAD = $user.coSuffix
            $StreetaddressAD = $user.streetaddress
            $CityAD = $user.city
            $StateAD = $user.state
            $PostalCodeAD = $user.postalcode
            $CountryAD = $user.country
            $upnSuffixAD = $user.upnSuffix
            $passwordAD = $user.password
            #$OUAD = $OU
            $CompanyAD = $CompAD + ", " + $coSuffixAD
            $UserPrincipalnameAD = $GivenNameAD + "." + $SurnameAD + $upnSuffixAD  
            
            New-Item -Path $dir -name results_$SamAccountNameAD.csv -Force -ItemType File

            # Create the users in Active Directory

        New-ADUser `
                   `
                -SAMAccountName $samaccountnameAD `
                -Name $DisplayNameAD `
                -DisplayName $DisplayNameAD `
                -GivenName $GivenNameAD `
                -Surname $SurnameAD `
                -Emailaddress $EmailAddressAD `
                -Title $TitleAD `
                -Department $DepartmentAD `
                -Office $OfficeAD `
                -Description $DescriptionAD `
                -Manager $managerUNAD `
                -OfficePhone $OfficePhoneAD `
                -UserPrincipalName $UserPrincipalnameAD `
                -Company $CompanyAD `
                -Streetaddress $streetaddressAD `
                -City $cityAD `
                -State $stateAD `
                -PostalCode $postalcodeAD `
                -Country $countryAD `
                -Accountpassword (convertto-securestring $passwordAD -AsPlainText -Force);
                #-Path $ouAD;

                Add-Content -path $dir\results_$SAMAccountNameAD.csv -value "SAMAccountName,DisplayName,GivenName,Surname,EmailAddress,Title,Department,Office,Description,managerUN,OfficePhone,password" -passthru
                Add-Content -Path $dir\results_$SAMAccountNameAD.csv -Value "$SamAccountNameAD,$displayNameAD,"$GivenNameAD","$SuranameAD","$EmailAddressAD",$TitleAD,$DepartmentAD,$officeAD,$DescriptionAD,$managerUNAD,$officephoneAD,$PasswordAD" -passthru
    
# Email out the details of the newly created users 
# Change the below details based on your organization

$To = "ToEmail@domain.com"
$From = "FromEmail@domain.com"
$SMTP = "smtp.domain.com"
$Subject = 'User ' + $SAMAccountNameAD + ' has been created in Active Directory'
$Body = 'See attached file for user ' + $SAMAccountNameAD + '  that has been created in Active Directory. Please distribute to management as required.'
$Attach = "$dir\results_$SamAccountNameAD.csv"
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -Attachments $Attach -SmtpServer $SMTP
#Remove-Item -Path $dir\results_$SAMAccountNameAD.csv -Force
}  





