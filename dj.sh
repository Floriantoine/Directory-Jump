#!/bin/bash

# Répertoire de départ
start_dir="$HOME"

# Fichier d'historique
history_file="$HOME/.directory_jump_history"

exclude_dirs=(".cache" ".electron-gyp" ".vscode" ".gradle" ".local" ".platformio" ".idea" ".mozilla")

CURRENT_EDITOR="code"
CURRENT_TERM="kitty"

OPEN_ON_NEW_TERM=false
OPEN_ON_EDITOR=false

POSITIONAL_ARGS=()

MAX_DEPTH=4
INPUT=""


print_help() {
    echo "Usage: dj [OPTIONS]... [ARGS]..."
    echo
    echo "Options:"
    echo "  -c               Open in default editor (default: code)"
    echo "  -n, --new        Open in new terminal (default: kitty)"
    echo "  -e               Specify editor (default: code)"
    echo "  -t               Specify terminal (default: kitty)"
    echo "  -maxdepth N      Set maximum depth for directory search (default: 4)"
    echo "  -h  --help       Display this help message"
    echo
    echo "Examples:"
    echo "  dj -c            Open in default editor"
    echo "  dj --new         Open in new terminal"
    echo "  dj -e vim        Open in specified editor (vim)"
    echo "  dj -t gnome      Open in specified terminal (gnome-terminal)"
    echo "  dj -maxdepth 3   Set maximum depth to 3 for directory search"
    echo "  dj -h            Display this help message"
    echo
    echo "If no options are provided, the script will use the default behavior."
    echo "If neither -c nor -n is provided, the script will change the current terminal directory."
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -maxdepth)
            MAX_DEPTH=$2
            shift
            shift
            ;;
        -c)
            OPEN_ON_EDITOR=true
            shift
            ;;
        -n|--new)
            OPEN_ON_NEW_TERM=true
            shift
            ;;
        -h|--help)
            print_help
            shift
            return 0
            ;;
        -e)
            CURRENT_EDITOR="$2"
            echo "-- $CURRENT_EDITOR"
            shift
            shift
            ;;
        -t)
            CURRENT_TERM="$2"
            shift
            shift
            ;;
        -*|--*)
            echo "Unknown option $1"
            print_help
            return 1
            ;;
        *)
            INPUT=$1
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}"

# Fonction pour mettre à jour l'historique
update_history() {
    local selected_dir="$1"
    # Supprime l'entrée existante de l'historique
    sed -i "\|^$selected_dir$|d" "$history_file"
    # Ajoute l'entrée au début de l'historique
    echo -e "$selected_dir\n$(cat $history_file)" > "$history_file"
}

# Fonction pour récupérer les dossiers depuis l'historique
get_history() {
    [ -f "$history_file" ] && head --lines=3 "$history_file" || echo ""
}
# Fonction pour rechercher les dossiers et les fichiers
find_directories_and_files() {
    local history=$(get_history)
   find "$start_dir" \( ! -iname ".*" \) -type d -o -type f -mindepth 1 -maxdepth $MAX_DEPTH 2>/dev/null | grep -vE "$(IFS=\|; echo "${exclude_dirs[*]}")" | grep -F -v -x -e "$history" | sed "s|$start_dir/||"
}

# Liste des dossiers et des fichiers
directories_and_files=$(find_directories_and_files "")

# Utilisez rofi pour obtenir une entrée avec autocomplétion
selected_dir_or_file=$(echo -e "$(get_history)\n$directories_and_files" | rofi -dmenu -show-icons -p "Select a directory or file:" -i -filter "$INPUT")

# Vérifie si l'utilisateur a annulé la sélection

if [ -z "$selected_dir_or_file" ]; then
   return 0
fi

# Ajoute le chemin complet du dossier sélectionné à l'historique
update_history "$selected_dir_or_file"

# Ajoute le chemin complet du dossier sélectionné
selected_dir="$start_dir/$selected_dir_or_file"

# Vérifie si l'argument -n a été fourni
if [ -f "$selected_dir" ]; then
   $CURRENT_EDITOR "$selected_dir"
elif $OPEN_ON_EDITOR ; then
    $CURRENT_EDITOR "$selected_dir"
elif $OPEN_ON_NEW_TERM; then
    # Ouvre un nouveau terminal kitty dans le dossier sélectionné
    $CURRENT_TERM --directory="$selected_dir"
else
    cd "$selected_dir"
    # Déplace le terminal actuel vers le nouveau répertoire
fi

# Affiche un message indiquant que le script s'est exécuté avec succès
echo "Script terminé avec succès."
