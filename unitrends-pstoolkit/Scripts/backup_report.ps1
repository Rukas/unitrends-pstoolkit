Import-Module C:\unitrends\dev\unitrends-pstoolkit\unitrends-pstoolkit\Unitrends.psd1

Connect-UebServer -Server ueb08 -User root -Password password

(Get-UebApi -uri "api/catalog/?view=instance").catalog | %{ $c=$_ ; $_.backups } |  Select start_date, id, @{Name='Name';Expression= {$c.database_name}}, @{Name='Status';Expression={if($_.status -eq 0) { "Sucessful"} else { "Failed"}}} | Export-Csv \\ueb08\samba\report.csv
