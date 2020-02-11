Write-Host " 1- Un Utilisateur"
Write-Host " 2- Import utilisateurs par fichier csv"
Write-Host " 3- EXIT"
$SelectScript = Read-Host
switch ($SelectScript) {1 {$Firstname = Read-Host ("Prenom")
  $Lastname = Read-Host ("Nom")
  $OU = Read-Host ("OU")
  $Group = Read-Host ("Groupe")
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
    "Direction Marketing" {$OU = "OU=DirectionMarketing,DC=acme,DC=fr"}
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
  }}
2 {# Importer des utilisateurs AD à partir d'un fichier CSV
# Chemin d’accès vers votre fichier d’importation CSV
$ADUsers = Import-csv -Delimiter ";" C:\Users\Administrateur\Desktop\useraccount.csv

foreach ($User in $ADUsers)
{
  $Firstname = $User.firstname
  $Lastname = $User.lastname
  $Username = $Firstname + "." + $Lastname
  $Password = $User.password
  $OU = $User.ou
  $Group = $User.group

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
            -UserPrincipalName "$Username@acme.fr" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
     Add-ADGroupMember -Identity $Group -Members $Username
     New-Item -Path C:\Serveur\UserDirectory\$Username -ItemType Directory
     New-SmbShare -Name $Username -Path C:\Serveur\UserDirectory\$Username -FullAccess $Username
   }
}
}
3 {EXIT}
}
