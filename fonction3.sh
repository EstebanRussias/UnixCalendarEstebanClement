#!/bin/bash

# Fonction pour calculer le nombre total d'heures par semaine
calculer_heures_par_semaine() {
    # Vérifier si le fichier a été passé en paramètre
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <fichier.json>"
        return 1
    fi

    # Vérifier si le fichier existe
    if [[ ! -f $1 ]]; then
        echo "Le fichier $1 n'existe pas."
        return 1
    fi

    # Extraire les données du fichier JSON et calculer les heures par semaine
    jq -r '
    .rows[] |
    . as $row |
    (.srvTimeCrDateFrom | sub("T.*"; "") | strptime("%Y-%m-%d") | strftime("%V")) as $week |
    ($week | tonumber) as $week_num |
    (($row.timeCrTimeTo - $row.timeCrTimeFrom) / 100) as $hours |
    {"semaine": $week_num, "heures": $hours}' "$1" |
    jq -s '
    group_by(.semaine) |
    map({"semaine": .[0].semaine, "total_heures": (map(.heures) | add)}) |
    .[] | "Semaine " + (.semaine | tostring) + " il y a " + (.total_heures | tostring) + " heures"
    '
}

# Appel de la fonction avec le fichier passé en paramètre
calculer_heures_par_semaine "$1"


