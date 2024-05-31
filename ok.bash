 outdated_dep=$(flutter pub outdated --json --no-prereleases --no-dev-dependencies)
          nb_outdated_dep=$(echo $outdated_dep | jq '[.packages[] | select(.kind == "direct")] | length')
          message="Nombre de paquets a mettre a jour en version majeure : $nb_outdated_dep"
          echo $message
          echo $message >> $GITHUB_STEP_SUMMARY
          if (( $nb_outdated_dep > ${{ inputs.max_obsolete_packages }} ));
           then
            message="❌ Le projet a trop de dépendances obsolètes ($nb_outdated_dep), il faut ${{ inputs.max_obsolete_packages }} maximum"
            echo $message
            echo $message >> $GITHUB_STEP_SUMMARY
            upgradable_dep=$(echo $outdated_dep  | jq '[.packages[] | select(.kind == "direct") | {package: .package, upgradable_version: .upgradable.version}]')
            echo $upgradable_dep
            echo $upgradable_dep >> $GITHUB_STEP_SUMMARY
            exit 1
          fi