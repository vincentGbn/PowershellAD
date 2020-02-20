#Script de sauvegarde des Documents des utilisateurs d'un poste
$CheminSupprSAV = "\\Srvcddlma01\SAV\*"
$NomMachine = [system.environment]::MachineName
$MonFolder = Get-ChildItem -Path C:\Users #Liste des sous répertoire des utilisateurs
$CheminRacineSAV = "\\Srvcddlma01\SAV\"
$Suppression = "\\Srvcddlma01\SAV\" + $NomMachine
Write-Host $MonFolder
Remove-Item -Path $Suppression -Force -Recurse #suppression de la sauvegarde précédente
New-Item -Path $CheminRacineSAV  -Name $NomMachine -ItemType Directory
foreach ($MySubFolder in $MonFolder) #Boucle de parcours de la liste
{
  $CheminSAV = $CheminRacineSAV + $NomMachine + "\" + $MySubFolder

  New-Item -Path $CheminSAV -Name $MySubFolder -ItemType Directory
  Copy-Item -Path C:\Users\$MySubFolder\Documents\ -Destination $CheminSAV  -Recurse -Force


}
