# Script permettant de lister les membre d'un groupe dans un fichier CSV
Param(
  [string]$groupe #Indication du groupe
)
Write-Host $groupe #Affiche le groupe choisi
Get-ADGroupMember $groupe |  Select-Object Name | Export-Csv $groupe".csv" -Encoding UTF8 #Creation du dossier csv
