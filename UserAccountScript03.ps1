# Importer des utilisateurs AD à partir d'un fichier CSV
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
