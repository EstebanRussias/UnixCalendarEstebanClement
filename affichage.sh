#!/bin/bash

fichier_actif=""

# Fonction pour choisir l'utilisateur
identifier_utilisateur() {
    while true; do
        echo "=== Identification ==="
        echo ""
        echo "Qui êtes-vous ?"
        echo "1. Élève"
        echo "2. Professeur"
        echo ""
        echo -n "Votre choix : "
        read -r utilisateur

        case $utilisateur in
            1)
                fichier_actif="etudiant.json"
                echo ""
                echo "Vous avez choisi Élève. Fichier actif : $fichier_actif"
                break
                ;;
            2)
                fichier_actif="prof.json"
                echo "Vous avez choisi Professeur. Fichier actif : $fichier_actif"
                break
                ;;
            *)
                echo "Choix invalide. Veuillez entrer 1 ou 2."
                ;;
        esac
    done
}

# Fonction pour afficher le menu
afficher_menu() {
    echo "=== Menu des Fonctions ==="
    echo "Le fichier utilisé est le fichier $fichier_actif"
    if [[ $fichier_actif == "etudiant.json" ]]; then
        echo "1. Afficher les cours de l'élève"
        echo "2. Afficher les contrôles de l'élève"
    elif [[ $fichier_actif == "prof.json" ]]; then
        echo "3. Afficher le nombre d'heures d'un professeur"
    fi
    echo "4. Afficher les temps libres entre le professeur et l'élève"
    echo "5. Changer d'utilisateur"
    echo "6. Quitter"
    echo "==========================="
    echo -n "Choisissez une option : (1-6) "
}

# Identification initiale
identifier_utilisateur

# Boucle principale du menu
while true; do
    afficher_menu
    read -r choix

    case $choix in
        1)
            if [[ $fichier_actif == "etudiant.json" ]]; then
                if [[ -f "$fichier_actif" ]]; then
                    bash fonction1.sh "$fichier_actif"
                else
                    echo "Fichier $fichier_actif non trouvé. Veuillez vérifier qu'il existe."
                fi
            else
                echo "Option réservée aux élèves. Vous êtes identifié comme Professeur."
            fi
            ;;
        2)
            if [[ $fichier_actif == "etudiant.json" ]]; then
                if [[ -f "$fichier_actif" ]]; then
                    bash fonction2.sh "$fichier_actif"
                else
                    echo "Fichier $fichier_actif non trouvé. Veuillez vérifier qu'il existe."
                fi
            else
                echo "Option réservée aux élèves. Vous êtes identifié comme Professeur."
            fi
            ;;
        3)
            if [[ $fichier_actif == "prof.json" ]]; then
                if [[ -f "$fichier_actif" ]]; then
                    bash fonction3.sh "$fichier_actif"
                else
                    echo "Fichier $fichier_actif non trouvé. Veuillez vérifier qu'il existe."
                fi
            else
                echo "Option réservée aux professeurs. Vous êtes identifié comme Élève."
            fi
            ;;
        4)
            echo "Les temps libres sont calculés à partir des deux fichiers : etudiant.json et prof.json."
            if [[ -f "etudiant.json" && -f "prof.json" ]]; then
                bash fonction5.sh
            else
                echo "Un ou plusieurs fichiers requis sont manquants. Veuillez vérifier."
            fi
            ;;
        5)
            echo "Retour au menu d'identification..."
            identifier_utilisateur
            ;;
        6)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Option invalide. Veuillez choisir une option entre 1 et 6."
            ;;
    esac

    echo ""
done
