#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

# invoke in directory holdling *.json scrapes
# ./renamer

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
    printf "Total elapsed time: %02d:%02d (MM:SS)\n" "$total_minutes" "$total_seconds"
}

new_step 'take attendance: ls -alh'
    ls -alh

new_step 'Name pattern: Prefix_Folder_Subfolder_ID.json'
for file in *_*_*_*.json; do
    # Extract everything after the last underscore
    newname="${file##*_}"
    sub_step 'mv -v "$file" "$newname"'
              mv -v "$file" "$newname"
done

new_step 'take attendance: ls -alh'
    ls -alh

new_step "Name pattern text after the ID but before the extension"
for file in *.json; do
    # Check if the filename contains a space (indicating a descriptive suffix)
    if [[ "$file" == *" "* ]]; then
        # Extract the part that looks like the ID (digits and dots)
        # This regex looks for the first sequence of numbers/dots
        if [[ $file =~ ([0-9]+\.[0-9.]+) ]]; then
            sub_step 'newname="${BASH_REMATCH[1]}.json"'
                      newname="${BASH_REMATCH[1]}.json"
            sub_step 'mv -v "$file" "$newname"'
                      mv -v "$file" "$newname"
        fi
    fi
done

new_step 'take attendance: ls -alh'
    ls -alh

new_step 'IIR2_'
for file in *IIR2\ WORKSHEET*.json; do
    # Remove everything up to and including 'WORKSHEET_'
    sub_step 'newname="${file#*WORKSHEET_}"'
              newname="${file#*WORKSHEET_}"
    sub_step 'mv -v "$file" "$newname"'
              mv -v "$file" "$newname"
done

new_step 'take attendance: ls -alh'
                           ls -alh 

new_step 'mv SW\ Integration\ \&\ Test\ SW.json 1.16.09.03.json'
          mv SW\ Integration\ \&\ Test\ SW.json 1.16.09.03.json

new_step 'take attendance: ls -alh'
                           ls -alh

display_total_elapsed_time 


