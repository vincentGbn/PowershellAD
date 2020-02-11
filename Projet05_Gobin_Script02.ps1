# Script permettant de lister les membre d'un groupe dans un fichier CSV
Param(
  [string]$groupe
)
Write-Host $groupe

Get-ADGroupMember $groupe |  Select-Object Name | Export-Csv $groupe".csv" -Encoding UTF8
