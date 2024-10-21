## TODO

[x] sauvegarder la vue dans une tbale à chaque heure (garder seulement 1 semaine) (ELEC_1h_COMMANDES_LN)
[x] avoir un line chart avec les données de cette vue pour avoir:
    [x] le total des lignes aujourd'Hui, par heures
    [x] la moyenne des lignes de la semaine dernière, par heure (en shadow)
    [x] le total actuel MAJ aux 5 min.

[x] convertir en components
    - améliorer la gestion des components
    - au lieu d'appeler un API, est-ce qu'on peut appeler directement la même function?
    
[x] retirer les statistiques de la fin de semaine? au moins samedi 5am à lundi 4h59am

[x] ne pas prendre ne compte les lignes livrées inutiles
    - qte = 0, type, isstock, autres?

[x] corriger le chargement de (total, livrees, restantes) qui affiche parfois 0
[x] sélectionner les transactions selon les groupes d'usagers au lieu de les hardcoder
[x] toruver une façon d'afficher aussi le nombre de commandes.
- simplifier l'API pour exporter à PowerBI
- authentification
- page d'accueil
- dashboard de gestion/coûts/marges
