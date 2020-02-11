#Ajouter un compte utilisateur dans son OU spécifique avec des questions + Creaton du dossier partagé à son nom

#Creation des variables (questions)
$nom = Read-Host ("nom utilisateur")
$prenom = Read-Host ("prenom")
$login = $prenom + "." + $nom
$nomcomplet = $prenom + " " + $nom
$nomprincipal = $login + "@" + "acme.fr"
$useroffice = Read-Host ("OU")
$groupe = Read-Host ("Groupe")
#Ajout des OU
switch($useroffice) {
  "DirectionGenerale" {$useroffice = "OU=DirectionGenerale,DC=acme,DC=fr"}
  "RessourcesHumaines" {$useroffice = "OU=RessourcesHumaines,DC=acme,DC=fr"}
  "DirectionTechnique" {$useroffice = "OU=DirectionTechnique,DC=acme,DC=fr"}
  "DirectionFinanciere" {$useroffice = "OU=DirectionFinanciere,DC=acme,DC=fr"}
  "DirectionMarketing" {$useroffice = "OU=DirectionMarketing,DC=acme,DC=fr"}
    "" {$useroffice = Read-Host "l'indication de l'OU est obligatoire"}
}
#Ajout de l'utilisateur dans son OU spécifique et dans son groupe
try {
  New-ADUser -Name $nomcomplet -GivenName $prenom -Surname $nom -SamAccountName $login -UserPrincipalName $nomprincipal -Path $useroffice -AccountPassword (ConvertTo-SecureString "Acme.fr2020" -AsPlainText -force) -ChangePasswordAtLogon $True -Enabled $true
  Add-ADGroupMember -Identity $groupe -Members $login
#Creaton du dossier partagé à son nom
  New-Item -Path C:\DATA\$prenom -ItemType Directory
  New-SmbShare -Name $nom -Path C:\DATA\$prenom
  echo "Utilisateur ajouté : $nomcomplet"
}
catch{
#Message en cas d'erreur
  echo "Utilisateur non ajouté : $nomcomplet"
}
