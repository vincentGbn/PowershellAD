
param (
  $SelectScript
)
#Création d'un menu
switch ($SelectScript) {1 {$Firstname = Read-Host ("Prenom")
#creation des variables
  $Lastname = Read-Host ("Nom")
  $OU = Read-Host ("OU")
  $Group = Read-Host ("Groupe")
  $Username = $Firstname + "." + $Lastname
  $CompleteName = $Firstname + " " + $Lastname
  $NomDeDomaine = "acme.fr"
  $courriel = $Username + "@" + $NomDeDomaine
  $CheminServer = "C:\Serveur\UserDirectory\" + $Username
  $mdp = "Acme.fr2020"
#affiche le prenom, le nom, l'OU et le groupe
  Write-Host $Firstname
  Write-Host $Lastname
  Write-Host $OU
  Write-Host $Group
  If ($Firstname -eq "") # si le prenom est nul, cela pose la question
  {
    $Firstname = Read-Host "Veillez indiquer votre prenom"
  }
  If ($Lastname -eq "") # si le nom est nul, cela pose la question
  {
    $Lastname = Read-Host "Veillez indiquer votre nom"
  }
#Parametrage pour les OUs
  switch($OU) {
    "Direction Generale" {$OU = "OU=DirectionGenerale,DC=acme,DC=fr"}
    "Ressources Humaines" {$OU = "OU=RessourcesHumaines,DC=acme,DC=fr"}
    "Direction Technique" {$OU = "OU=DirectionTechnique,DC=acme,DC=fr"}
    "Direction Financiere" {$OU = "OU=DirectionFinanciere,DC=acme,DC=fr"}
    "Direction Marketing" {$OU = "OU=DirectionMarketing,DC=acme,DC=fr"}
    "" {$OU = Read-Host ("L'Ou est obligatoire")}
  }
  #Creation de l'utilisateur
  try {
    New-ADUser -Name $CompleteName -GivenName $Firstname -Surname $Lastname -SamAccountName $Username -UserPrincipalName $courriel -Path $OU -AccountPassword (ConvertTo-SecureString $mdp -AsPlainText -force) -ChangePasswordAtLogon $True -Enabled $true
    Add-ADGroupMember -Identity $group -Members $Username # ajout de l'utilisateur dans son groupe
    New-Item -Path $CheminServer -ItemType Directory # creation de son dossier
    New-SmbShare -Name $Username -Path $CheminServer -FullAccess $Username # Partage de son dossier
    Add-NTFSAccess –Path $CheminServer –Account $courriel –AccessRights Modify # Permission "Modifier" uniquement pour l'utilisateur
    echo "Utilisateur ajouté : $CompleteName"
  }
  catch {
    echo "Utilisateur non ajouté : $CompleteName" #Affichage en cas d'erreur
  }}
2 {# Importer des utilisateurs AD à partir d'un fichier CSV
# Chemin d’accès vers votre fichier d’importation CSV
$CheminCsv = "C:\Users\Administrateur\Desktop\useraccount.csv"
$ADUsers = Import-csv -Delimiter ";" $CheminCsv

foreach ($User in $ADUsers) #Creation des variables pour les utilisateurs
{
  $Firstname = $User.firstname
  $Lastname = $User.lastname
  $Username = $Firstname + "." + $Lastname
  $Password = $User.password
  $OU = $User.ou
  $Group = $User.group
  $CheminServer = "C:\Serveur\UserDirectory\" + $Username
  $NomDeDomaine = "acme.fr"
  #Vérifiez si le compte utilisateur existe déjà dans AD
   if (Get-ADUser -F {SamAccountName -eq $Username})
   {
     #Si l’utilisateur existe, éditez un message d’avertissement
     Write-Warning "Le compte $Username existe déja."
   }
   else
   {
     #Si un utilisateur n’existe pas, créez un nouveau compte utilisateur
     New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$NomDeDomaine" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
     Add-ADGroupMember -Identity $Group -Members $Username # ajout de l'utilisateur dans son groupe
     New-Item -Path $CheminServer -ItemType Directory # creation des dossiers
     New-SmbShare -Name $Username -Path $CheminServer -FullAccess $Username # Partage des dossiers
     Add-NTFSAccess –Path $CheminServer –Account "$Username@$NomDeDomaine" –AccessRights Modify # Permission "Modifier" uniquement pour l'utilisateur
   }
}
}
3 {EXIT}
}
