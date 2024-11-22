#!/bin/bash

# Créé par Clément

# Fonction pour afficher les contrôles depuis un fichier JSON
afficher_controle() {
    # Vérifier si un fichier JSON est passé en paramètre
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <fichier.json>"
        return 1
    fi

    # Vérifier si le fichier existe
    if [[ ! -f $1 ]]; then
        echo "Le fichier $1 n'existe pas."
        return 1
    fi

    echo "Liste des contrôles :"
    echo

    # Extraire et afficher les données du fichier JSON
    jq -r '
    .rows[] |
    select(.srvTimeCrActivityId | test("SURVEILLANCE|CONTROLECRIT")) |
    (.srvTimeCrDateFrom | sub("T.*"; "") | strptime("%Y-%m-%d") | strftime("%d %B %Y")) as $date |
    ($date + "\n" +
    "Horaire : " +
    ((.timeCrTimeFrom / 100 | floor | tostring | if length == 1 then "0" + . else . end) + ":" +
    (.timeCrTimeFrom % 100 | tostring | if length == 1 then "0" + . else . end)) + " à " +
    ((.timeCrTimeTo / 100 | floor | tostring | if length == 1 then "0" + . else . end) + ":" +
    (.timeCrTimeTo % 100 | tostring | if length == 1 then "0" + . else . end)) + "\n" +
    "Le contrôle : " + (.prgoOfferingDesc | sub(" \\(.*\\)"; "")) + "\n")' "$1"
}

# Appel de la fonction avec le fichier passé en paramètre
afficher_controle "$1"
