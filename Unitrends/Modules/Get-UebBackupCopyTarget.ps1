<#
.SYNOPSIS
Returns a list of backup copy target servers
.DESCRIPTION
Uses the Unitrends API to get a list of backup copy targets
.PARAMETER Name
The name of the backup copy target
.EXAMPLE 
Get-UebBackupCopyTarget
Returns all UEB backup copy targets
.EXAMPLE 
Get-UebBackupCopyTarget -Name "ueb-02"
Returns the backup copy target with a name of ueb-02
#>
Function Get-UebBackupCopyTarget {

    [CmdletBinding()]
	param (

        [Parameter(Mandatory=$false)]
        [string]$Name

	)

    $response = (UebGet "api/backup-copy/connected_targets").data

    If($Name){

        $response | Where-Object { $_.name -like $Name }

    }
    Else{
        
        $response

    }

}