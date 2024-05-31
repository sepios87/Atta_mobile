outdated_dep=$(flutter pub outdated --json --no-prereleases --no-dev-dependencies)
back=$(echo "$outdated_dep" | grep -B 5 '"kind": "direct"' | grep '"package":' | cut -d '"' -f 4)
echo "$back"
nb=$(echo "$back" | wc -l)
echo "$nb"