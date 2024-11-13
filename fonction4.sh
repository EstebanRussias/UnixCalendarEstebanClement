#!/bin/bash

# Fonction pour afficher toutes les prochaines dates et heures d'un module donné
afficher_prochaines_seances() {
    # Vérifier si le bon nombre d'arguments est passé
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <fichier.json> <module>"
        return 1
    fi

    # Vérifier si le fichier existe
    local fichier_json=$1
    local module_id=$2
    if [[ ! -f $fichier_json ]]; then
        echo "Le fichier $fichier_json n'existe pas."
        return 1
    fi

    # Extraire les données du fichier JSON pour le module donné et les afficher
    jq -r --arg module "$module_id" '
    .rows[] |
    select(.soffServiceId == $module) |
    .srvTimeCrDateFrom |= sub("T.*"; "") |
    "\(.srvTimeCrDateFrom | strptime(\"%Y-%m-%d\") | strftime(\"%d %B %Y\")) - " +
    (.timeCrTimeFrom / 100 | floor | tostring | lpad(2, "0")) + ":" +
    (.timeCrTimeFrom % 100 | tostring | lpad(2, "0")) + " à " +
    (.timeCrTimeTo / 100 | floor | tostring | lpad(2, "0")) + ":" +
    (.timeCrTimeTo % 100 | tostring | lpad(2, "0"))
    ' "$fichier_json"
}

# Fonction d'ajustement pour afficher les heures avec deux chiffres
jq -n 'def lpad($n; $c): . as $in | ($in | length) as $len | if $len < $n then ($c * ($n - $len) + $in) else $in end'

# Appel de la fonction avec le fichier JSON et le module passés en paramètre
afficher_prochaines_seances "$1" "$2"
