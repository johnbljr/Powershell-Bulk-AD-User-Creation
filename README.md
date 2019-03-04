# Powershell Bulk User AD Creation
Create user in Active Directory from a csv file.
This script will do the following:
1. Read your input file for the usernames your are creating
2. Scan that list against Active Directory
3. Verify you are not duplicating any usernames
4. If you have a duplicate username it will send out an email to you telling you which username is already in use.
5. The script then pulls out the users that do not exist in AD and creates a new import file.
6. The script will then create the users in Active Directory from this file and populate the following information:
                -SAMAccountName
                -Name
                -DisplayName
                -GivenName
                -Surname
                -Emailaddres
                -Title
                -Department
                -Office
                -Description
                -Manager
                -OfficePhone
                -UserPrincipalName
                -Company
                -Streetaddress
                -City
                -State
                -PostalCode
                -Country
                -Accountpassword
                -Enabled
      Note: For more properties and explanations please see the Microsoft arcicle: https://docs.microsoft.com/en-us/powershell/module/activedirectory/new-aduser?view=winserver2012-ps
7. The script will then send you an email confirmation that the user was created along with their details. 

Revision Changes

March 4, 2019
Initial Release v1.0
