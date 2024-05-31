# Obtenir les dépendances en format JSON
outdated_dep=$(flutter pub outdated --json --no-prereleases --no-dev-dependencies)

# Utiliser un heredoc pour conserver le format JSON et manipuler avec jq
nb_outdated_dep=$(jq '[.packages[] | select(.kind == "direct")] | length' <<< "$outdated_dep")

# Afficher le nombre de dépendances directes obsolètes
echo "Number of outdated dependencies: $nb_outdated_dep"