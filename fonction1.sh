#!/bin/bash

#Clement 

# Fonction pour afficher le planning
afficher_planning() {
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


    # Afficher l'en-tête
    echo "Planning des cours de Mikael VALOT pour début octobre 2024 :"
    echo


    # Extraire les données du fichier JSON et les afficher
    jq -r '
    .rows[] |
    (.srvTimeCrDateFrom | sub("T.*"; "") | strptime("%Y-%m-%d") | strftime("%d %B %Y")) as $date |
    # Formater les heures avec des zéros à gauche si nécessaire
    ($date + " " +
    "- " +
    ((.timeCrTimeFrom / 100 | floor | tostring | if length == 1 then "0" + . else . end) + ":" +
    (.timeCrTimeFrom % 100 | tostring | if length == 1 then "0" + . else . end)) + " à " +
    ((.timeCrTimeTo / 100 | floor | tostring | if length == 1 then "0" + . else . end) + ":" +
    (.timeCrTimeTo % 100 | tostring | if length == 1 then "0" + . else . end)) + " : " +
    .prgoOfferingDesc + " (" + .srvTimeCrDelRoom + ")")' "$1"
}


# Appel de la fonction avec le fichier passé en paramètre
afficher_planning "$1"



