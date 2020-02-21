#Script de sauvegarde des Documents des utilisateurs d'un poste
#creation des variables
$CheminSupprSAV = "\\Srvcddlma01\SAV\*"
$NomMachine = [system.environment]::MachineName
$MonFolder = Get-ChildItem -Path C:\Users #Liste des sous répertoire des utilisateurs
$CheminRacineSAV = "\\Srvcddlma01\SAV\"
$Suppression = "\\Srvcddlma01\SAV\" + $NomMachine
Write-Host $MonFolder
Remove-Item -Path $Suppression -Force -Recurse #suppression de la sauvegarde précédente
New-Item -Path $CheminRacineSAV  -Name $NomMachine -ItemType Directory #Creation du dossier avec le nom de la machine
foreach ($MySubFolder in $MonFolder) #Boucle de parcours de la liste
{
  $CheminSAV = $CheminRacineSAV + $NomMachine + "\" + $MySubFolder

  New-Item -Path $CheminSAV -Name $MySubFolder -ItemType Directory #Creation du dossier ou la sauvegarde va etre envoyé
  Copy-Item -Path C:\Users\$MySubFolder\Documents\ -Destination $CheminSAV  -Recurse -Force #Copie des documents vers le dossier en question


}
