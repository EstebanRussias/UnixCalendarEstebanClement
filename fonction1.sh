#!/bin/bash

# auteur : Clément

# fonction pour afficher le planning
afficher_planning() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <fichier.json>"
        return 1
    fi
    # existe ?
    if [[ ! -f $1 ]]; then
        echo "Le fichier $1 donné en argument n'a pas été trouvé !!!"
        return 1
    fi

    echo "Planning des cours pour début octobre 2024 :"
    echo

    # extraire les données du fichier JSON et les afficher
    jq -r '
    .rows[] |
    (.srvTimeCrDateFrom | sub("T.*"; "") | strptime("%Y-%m-%d") | strftime("%d %B %Y")) as $date |
    ($date + "\n" +
    "Horaire : " +
    ((.timeCrTimeFrom / 100 | floor | tostring | if length == 1 then "0" + . else . end) + ":" +
    (.timeCrTimeFrom % 100 | tostring | if length == 1 then "0" + . else . end)) + " à " +
    ((.timeCrTimeTo / 100 | floor | tostring | if length == 1 then "0" + . else . end) + ":" +
    (.timeCrTimeTo % 100 | tostring | if length == 1 then "0" + . else . end)) + "\n" +
    "Cours : " + .prgoOfferingDesc + "\n" +
    "Classe : " + (.srvTimeCrDelRoom | split(",") | .[1:3] | join(",")) + "\n")' "$1"
}

afficher_planning "$1"
