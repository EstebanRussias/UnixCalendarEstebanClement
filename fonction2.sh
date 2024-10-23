#!/bin/bash

# Crée par Esteban

function futurControle(){
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

    # Vérifier si le fichier est lisible
    if [[ ! -r $1 ]]; then
        echo "Le fichier $1 n'est pas lisible."
        return 1
    fi

    # Utiliser jq pour filtrer les données JSON
    jq '.rows[] | select(.srvTimeCrActivityId == "SURVEILLANCE")' "$1"
}

# Appeler la fonction avec le paramètre passé au script
futurControle "$1"
