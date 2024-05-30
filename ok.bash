output_code=$(flutter pub run dart_code_linter:metrics check-unused-code lib 2>&1 || true)
          nb_unused_code=$(echo $output_code | rev | cut -f1 -d' ')
          if [ -z $nb_unused_code ]; then 
            message="✅ Aucun code non utilisé"
            echo $message
          else
            if (( $nb_unused_code > 0 )); then
              message="⚠️ Quantité de code non utilisée : $nb_unused_code"
              echo $message
              echo "$output_code"
            fi
            if (( $nb_unused_code > 5 )); then
              message="❌ Le projet a trop de code inutilisé ($nb_unused_code), il faut ${{ inputs.max_unused_code }} maximum"
              echo $message
              echo $output_code
              exit 1
            fi
          fi
echo "coucou"