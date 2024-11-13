#!/bin/bash

# Fonction pour trouver les créneaux libres en comparant les cours des étudiants et du professeur
creer_creneaux_libres() {
    # Définir les fichiers JSON
    local etudiants_json="student.json"
    local prof_json="prof_full.json"

    # Vérifier si les fichiers existent
    if [[ ! -f $etudiants_json ]] || [[ ! -f $prof_json ]]; then
        echo "Erreur : l'un des fichiers ou les deux n'existent pas."
        return 1
    fi

    # Définir la plage horaire du campus
    local heure_debut_journee=800
    local heure_fin_journee=2000

    # Extraire les créneaux des étudiants
    jq -r '.rows[] | [.srvTimeCrDateFrom, .timeCrTimeFrom, .timeCrTimeTo] | @tsv' "$etudiants_json" > etudiants_creneaux.txt

    # Extraire les créneaux du professeur
    jq -r '.rows[] | [.srvTimeCrDateFrom, .timeCrTimeFrom, .timeCrTimeTo] | @tsv' "$prof_json" > prof_creneaux.txt

    # Fonction pour vérifier et afficher les créneaux libres
    check_creanaux_libres() {
        local date=$1
        local start=$2
        local end=$3
        local libre_start=$start

        # Lire les créneaux de l'étudiant et exclure les créneaux occupés
        while IFS=$'\t' read -r date_etud start_etud end_etud; do
            if [[ "$date" == "$date_etud" ]]; then
                # Créer des créneaux libres entre les horaires des cours étudiants
                if (( libre_start < start_etud && start_etud < end )); then
                    echo "Créneau libre le $(date -d "$date" +"%d %B %Y") de $((libre_start / 100))h$((libre_start % 100)) à $((start_etud / 100))h$((start_etud % 100))"
                    libre_start=$end_etud
                fi
                # Mettre à jour la fin du créneau libre si chevauchement
                if (( libre_start < end_etud && end_etud < end )); then
                    libre_start=$end_etud
                fi
            fi
        done < etudiants_creneaux.txt

        # Lire les créneaux du professeur et exclure les créneaux occupés
        while IFS=$'\t' read -r date_prof start_prof end_prof; do
            if [[ "$date" == "$date_prof" ]]; then
                if (( libre_start < start_prof && start_prof < end )); then
                    echo "Créneau libre le $(date -d "$date" +"%d %B %Y") de $((libre_start / 100))h$((libre_start % 100)) à $((start_prof / 100))h$((start_prof % 100))"
                    libre_start=$end_prof
                fi
                if (( libre_start < end_prof && end_prof < end )); then
                    libre_start=$end_prof
                fi
            fi
        done < prof_creneaux.txt

        # Afficher le dernier créneau libre jusqu'à la fin de la journée
        if (( libre_start < end )); then
            echo "Créneau libre le $(date -d "$date" +"%d %B %Y") de $((libre_start / 100))h$((libre_start % 100)) à $((end / 100))h$((end % 100))"
        fi
    }

    # Boucle pour parcourir les dates dans les fichiers et afficher les créneaux libres pour chaque jour
    cat etudiants_creneaux.txt prof_creneaux.txt | cut -f1 | sort | uniq | while read -r date; do
        check_creanaux_libres "$date" "$heure_debut_journee" "$heure_fin_journee"
    done
}

# Appel de la fonction
creer_creneaux_libres



