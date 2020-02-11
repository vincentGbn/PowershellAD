#Ajouter un compte utilisateur dans son OU spécifique + Creaton du dossier partagé à son nom
Param(
    [string]$Lastname,
    [string]$Firstname,
    [string]$OU,
    [string]$Group
)
Write-Host $Firstname
Write-Host $Lastname
Write-Host $OU
Write-Host $Group
If ($Firstname -eq "")
{
  $Firstname = Read-Host "Veillez indiquer votre prenom"
}
If ($Lastname -eq "")
{
  $Lastname = Read-Host "Veillez indiquer votre nom"
}

$Username = $Firstname + "." + $Lastname
$CompleteName = $Firstname + " " + $Lastname
$courriel = $Username + "@" + "acme.fr"
switch($OU) {
  "Direction Generale" {$OU = "OU=DirectionGenerale,DC=acme,DC=fr"}
  "Ressources Humaines" {$OU = "OU=RessourcesHumaines,DC=acme,DC=fr"}
  "Direction Technique" {$OU = "OU=DirectionTechnique,DC=acme,DC=fr"}
  "Direction Financiere" {$OU = "OU=DirectionFinanciere,DC=acme,DC=fr"}
  "DirectionMarketing" {$OU = "OU=DirectionMarketing,DC=acme,DC=fr"}
  "" {$OU = Read-Host ("L'Ou est obligatoire")}
}
try {
  New-ADUser -Name $CompleteName -GivenName $Firstname -Surname $Lastname -SamAccountName $Username -UserPrincipalName $courriel -Path $OU -AccountPassword (ConvertTo-SecureString "Acme.fr2020" -AsPlainText -force) -ChangePasswordAtLogon $True -Enabled $true
  Add-ADGroupMember -Identity $group -Members $Username
  New-Item -Path C:\Serveur\UserDirectory\$Username -ItemType Directory
  New-SmbShare -Name $Username -Path C:\Serveur\UserDirectory\$Username -FullAccess $Username
  echo "Utilisateur ajouté : $CompleteName"
}
catch {
  echo "Utilisateur non ajouté : $CompleteName"
}
