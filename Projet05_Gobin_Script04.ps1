#Script de sauvegarde des Documents des utilisateurs d'un poste
$MonFolder = Get-ChildItem -Path C:\Users #Liste des sous répertoire des utilisateurs
Write-Host $MonFolder
Remove-Item -Path \\Srvcddlma01\SAV\* -Force -Recurse
foreach ($MySubFolder in $MonFolder) #Boucle de parcours de la liste
{

  New-Item -Path \\Srvcddlma01\SAV\ -Name $MySubFolder -ItemType Directory
  Copy-Item -Path C:\Users\$MySubFolder\Documents\ -Destination \\Srvcddlma01\SAV\$MySubFolder -Recurse -Force


}}
