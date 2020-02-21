# Script pour recuperer la liste des groupes dont un utilisateur est membre dans fichier CSV
#Parametrage prenom et nom
Param (
  $prenom,
  $nom
)
$login = $prenom + "." + $nom #creation de la variable qui corespond au login de l'utilisateur

  $user = Get-AdUser -Identity $login -Properties MemberOf #Creation de la variable qui corespond au groupe dont l'utilisateur est membre
  foreach($u in $user) { # Creation du fichier csv avec chaque groupe de l'utilisateur

    $nomcomplet = $u.name

    $membre = $u.memberof

    Add-Content -Path $nom".txt" -Value $nomcomplet

    Add-Content -Path $nom".txt" -Value $membre

}
