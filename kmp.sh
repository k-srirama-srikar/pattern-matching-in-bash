#!/bin/bash

# Function to preprocess the pattern and create the longest prefix suffix (LPS) array
computeLPSArray() {
    local pattern="$1"
    local lps=()
    local length=0
    local i=1
    local pat_len=${#pattern}

    lps[0]=0

    while [[ $i -lt $pat_len ]]; do
        if [[ ${pattern:i:1} == ${pattern:length:1} ]]; then
            ((length++))
            lps[i]=$length
            ((i++))
        else
            if [[ $length -ne 0 ]]; then
                length=${lps[length-1]}
            else
                lps[i]=0
                ((i++))
            fi
        fi
    done

    echo "${lps[@]}"
}

# KMP search function
KMPSearch() {
    local text="$1"
    local pattern="$2"
    local lps
    local text_len=${#text}
    local pat_len=${#pattern}
    local i=0
    local j=0

    # Compute the LPS array
    lps=($(computeLPSArray "$pattern"))

    while [[ $i -lt $text_len ]]; do
        if [[ ${pattern:j:1} == ${text:i:1} ]]; then
            ((i++))
            ((j++))
        fi

        if [[ $j -eq $pat_len ]]; then
            echo "Pattern found at index $((i - j))"
            j=${lps[j - 1]}
        elif [[ $i -lt $text_len && ${pattern:j:1} != ${text:i:1} ]]; then
            if [[ $j -ne 0 ]]; then
                j=${lps[j - 1]}
            else
                ((i++))
            fi
        fi
    done
}

# Example usage
text="ABABDABACDABABCABAB"
pattern="ABABCABAB"

KMPSearch "$text" "$pattern"

