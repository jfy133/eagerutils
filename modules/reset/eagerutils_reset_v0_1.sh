#!/usr/bin/env bash

## Resets an EAGER results directory as it was freshly generated
## Written by James A. Fellows Yates (jfy133@gmail.com).

IN="$1"

if [[ "$IN" == "" ]]; then
        echo "Usage: eagerutils reset <directory>"
        echo "See -h or --help for more information"
        exit 1
elif [[ "$#" != 1 ]]; then
        echo "Usage: eagerutils reset <directory>"
        echo "Please only supply a single sample directory, or a parent"
        echo "directory of multiple sample directories"
        exit 1
elif [[ "$IN" == "-h" ]] || [[ "$IN" == "--help" ]]; then
        echo "Usage: eagerutils reset <directory>"
        echo ""
        echo "Description: This will reset all directories containing XML files"
        echo "to contain only the XML file. Thus, 'resetting' all EAGER results"
        echo "directories as they were when freshly generated." 
        echo ""
        echo "Note: If a parent directory of multiple runs is supplied, This" 
        echo "will also remove ReportTable results. If only a single sample" 
        echo "directory is found (i.e. one XML), the ReportTable results will"
        echo "be retained"
        echo ""
        exit 0
## For when a single sample directory is provided
elif [[ $(find "$IN" -maxdepth 2 -name '*-EAGER.xml' -type f | wc -l) -eq 1 ]]; then
        echo ""
        while read XML; do
                DIR="$(readlink -f "$(echo "$XML" | rev | cut -d/ -f2-99 | rev)")"
                echo "Resetting directory" "$(echo "$DIR" | rev | cut -d/ -f1 | rev)"
                rm -r --preserve-root "${DIR:?}"/*/ 2> /dev/null
                rm --preserve-root "$DIR"/*.log 2> /dev/null
                rm --preserve-root "$DIR"/DONE* 2> /dev/null
        done < <(find "$IN" -name '*-EAGER.xml' -type f)
        echo ""
## For when a parent directory of multiple sample drectories are provided
elif [[ $(find "$IN" -maxdepth 3 -name '*-EAGER.xml' -type f | wc -l) -gt 1 ]]; then
        echo ""
        while read XML; do
                DIR="$(readlink -f "$(echo "$XML" | rev | cut -d/ -f2-99 | rev)")"
                echo "Resetting directory" "$(echo "$DIR" | rev | cut -d/ -f1 | rev)"
                rm -r --preserve-root "${DIR:?}"/*/ 2> /dev/null
                rm --preserve-root "$DIR"/*.log 2> /dev/null
                rm --preserve-root "$DIR"/DONE* 2> /dev/null
        done < <(find "$IN" -name '*-EAGER.xml' -type f)
        rm "$IN"/DONE* 2> /dev/null
        echo ""
fi

exit 0
