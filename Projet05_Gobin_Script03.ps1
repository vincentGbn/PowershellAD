# Script pour recuperer la liste des groupes dont un utilisateur est membre dans fichier CSV
Param (
  $prenom,
  $nom
)
$login = $prenom + "." + $nom

  $user = Get-AdUser -Identity $login -Properties MemberOf
  foreach($u in $user) {

    $nomcomplet = $u.name

    $membre = $u.memberof

    Add-Content -Path $nom".txt" -Value $nomcomplet

    Add-Content -Path $nom".txt" -Value $membre

}
