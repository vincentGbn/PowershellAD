# PowershellAD
P5_Gobin_Script01.ps1 : 2 scripts en 1 qui permet soit de créer un seul utilisateur dans l’AD avec un dossier partagé à son nom, ou bien de créer plusieurs utilisateurs (avec un dossier partagé pour chaque utilisateur créer) a l’aide d’un fichier csv. Les utilisateurs sont directement ajouté à leur groupe et leur OU.


P5_Gobin_Script02.ps1 : Script permettant de créer un fichier où il y est indiqué la liste des membre d’un groupe. Il suffit d’indiqué le nom du groupe en lançant le script pour créer le fichier avec la liste des membres du groupe choisi.

P5_Gobin_Script03.ps1 : Script permettant de créer un fichier où il y est indiqué la liste des groupes dont un utilisateur est membre. Il suffit d’indiqué le nom de l’utilisateur en lançant le script pour créer le fichier avec la liste des groupes dont l’utilisateur est membre.

P5_Gobin_Script04.ps1 : Script de sauvegarde automatique des documents des utilisateurs d’un poste de travail. Il crée un dossier par poste de travail (nom du poste), il annule et remplace à chaque exécution les documents précédemment sauvegardés. Il peut être planifié grâce au « Planificateur de Tâches » de Windows.
