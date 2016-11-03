<#
.SYNOPSIS
Gets the instances for the specified job
.DESCRIPTION
Uses the Unitrends API to get the instances for the specified job
.PARAMETER Name
The name of the job
.EXAMPLE 
Get-UebJobInstances -Name "ueb-job"
Returns the instances associated with the job "ueb-job"
#>
Function Get-UebJobInstances {

    [CmdletBinding()]
	param (

        [Parameter(Mandatory=$true)]
        [string]$Name

    )

    $j = Get-UebJob -Name $Name
	$id = $j.id
	$sid = $j.sid
    $jobname = $j.name

    $joborder = (Get-UebApi "api/joborders/$id/?sid=$sid").data

    $joborder.instances

}