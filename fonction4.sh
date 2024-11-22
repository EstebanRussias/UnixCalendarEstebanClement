#!/bin/bash


afficher_cours_formatte() {
    local fichier_json=$1

    if [ ! -f "$fichier_json" ]; then
        echo "Fichier JSON introuvable : $fichier_json"
        return 1
    fi

    # Extraire et formater les données
    jq -r '
        .rows[] |
        {
            cours: .prgoOfferingDesc,
            date: (.srvTimeCrDateFrom | sub("T.*"; "") | strptime("%Y-%m-%d") | strftime("%A %d %B")),
            heureDebut: (.timeCrTimeFrom | tostring | sub("([0-9]{1,2})([0-9]{2})"; "\\1h\\2")),
            heureFin: (.timeCrTimeTo | tostring | sub("([0-9]{1,2})([0-9]{2})"; "\\1h\\2")),
            duree: (.timeCrTimeTo - .timeCrTimeFrom) / 100
        }
    ' "$fichier_json" | awk '
        BEGIN { FS=":"; OFS=":" }
        {
            cours = $1
            dates[cours] = dates[cours] "\n→ " $2 " de " $3 " à " $4
            heures[cours] += $5
        }
        END {
            for (cours in dates) {
                print "Cours de " cours ":"
                print dates[cours]
                print "Nombre d’heure total : " heures[cours] "h\n"
            }
        }
    '
}

# Exemple d'utilisation
afficher_cours_formatte "prof.json"
