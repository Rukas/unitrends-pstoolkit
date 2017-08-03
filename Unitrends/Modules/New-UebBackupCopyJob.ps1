<#
.SYNOPSIS
Adds a Unitrends backup copy job to the current Unitrends server
.DESCRIPTION
Uses the Unitrends API to create a new backup copy job.
.PARAMETER Name
The name of the job
.PARAMETER Instances
An array of instance names.  These can be VMs or physical servers
.PARAMETER BackupCopyTarget
The name of the backup copy target.
.EXAMPLE 
New-UebBackupCopyJob -Name "test-job" -instances @('server01') -BackupCopyTarget "ueb-02"
Creates a scheduled incremental backup job
#>
Function New-UebBackupCopyJob {

    [CmdletBinding()]
	param (

        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Collections.ArrayList]$Instances,

        [Parameter(Mandatory=$true)]
		$BackupCopyTarget

	)


    #############################################################
    ##                     Global Variables                    ##
    #############################################################

    $instanceObjects = New-Object System.Collections.ArrayList


    #############################################################
    ##                   Validate Input Data                   ##
    #############################################################

    $jobOrders = (Get-UebApi "api/joborders").data

    #Check to see if a job with this name already exists
    If($jobOrders.name -contains "$Name"){

        Write-Error -Message "A job named $Name already exists in UEB"

        return

    }

    #Instances
    Foreach ($instance in $Instances){
        Write-Host "processing $Instance"

        if($instance -is [String]) {

            $object = Get-UebInventory -Name $instance | Select-Object -First 1

            If($object){
            
                $instanceObjects.Add($object) | Out-Null

            }
            Else{

                Write-Warning -Message "Unable to find $instance in the UEB inventory. Skipping it for now."

            }

        }
        Else{

            $instanceObjects.Add($instance) | Out-Null

        }


    }

    If($instanceObjects.Count -eq 0){

        Write-Error -Message "There were no valid instances passed. Unable to continue"

        return

    }

    $instanceIds = $instanceObjects.id

    #BackupCopyTarget Name
    If($BackupCopyTarget -is [string]){

        $BackupCopyTargetObj = Get-UebBackupCopyTarget -Name $BackupCopyTarget

    }
    Else{

        $BackupCopyTargetObj = $BackupCopyTarget

    }

    If(!$BackupCopyTargetObj){

        Write-Error -Message "$BackupCopyTarget is not a valid UEB backup copy target"

        return

    }

    $instanceIds.gettype()

    #############################################################
    ##                 Create Object for API Call              ##
    #############################################################

    $job = [pscustomobject] @{

        "name" = "$Name"
        "type" = "Replication"
        "instances" = [array]$instanceIds
        "target_id" = $BackupCopyTargetObj.target_id

    }

    $job


    #############################################################
    ##                          Call API                       ##
    #############################################################

    $response = UebPost "api/joborders" $job

    $job

}