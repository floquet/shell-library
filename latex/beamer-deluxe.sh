
#!/usr/bin/env bash
set -e

printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

counter=0
subcounter=0
start_time=${SECONDS}

function new_step() {
    export counter=$((counter + 1))
    export subcounter=0
    echo ""
    echo "Step ${counter}: ${1}"
}

function sub_step() {
    export subcounter=$((subcounter + 1))
    echo ""
    echo "  Substep ${counter}.${subcounter}: ${1}"
}

function display_total_elapsed_time() {
    local total_elapsed_time=$((SECONDS - start_time))
    local total_minutes=$((total_elapsed_time / 60))
    local total_seconds=$((total_elapsed_time % 60))
    echo ""
    printf "Total elapsed time: %02d:%02d (MM:SS)\n" \
        "$total_minutes" "$total_seconds"
}

# Document name
document="${1:-main}"
document="${document%.tex}"

# Verify source file
if [[ ! -f "${document}.tex" ]]; then
    echo "ERROR: Cannot find ${document}.tex"
    exit 1
fi

# Begin steps
new_step "First LaTeX pass"
         pdflatex -interaction=nonstopmode -halt-on-error \
             "${document}.tex"

new_step "Process bibliography"
         biber "$document"

new_step "Process glossaries"
         makeglossaries "$document"

new_step "Second LaTeX pass"
         pdflatex -interaction=nonstopmode -halt-on-error \
             "${document}.tex"

new_step "Final LaTeX pass"
         pdflatex -interaction=nonstopmode -halt-on-error \
             "${document}.tex"

new_step "Verify PDF"
         if [[ -s "${document}.pdf" ]]; then
             echo "Created: ${document}.pdf"
         else
             echo "ERROR: PDF missing or empty."
             exit 1
         fi

display_total_elapsed_time

