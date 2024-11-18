#!/bin/bash

file_name=""
coordinates=""

# Find the file containing "DIMENSION"
for file in *; do
  if [[ -f "$file" && $file != "script.sh" ]]; then
    if grep -q "DIMENSION" "$file"; then
      file_name=$file
    fi
  fi
done

# Debug: Print the file name
echo "File with DIMENSION: $file_name"

# Ensure file_name is not empty
if [[ -z "$file_name" ]]; then
  echo "Error: No file containing 'DIMENSION' found."
  exit 1
fi
declare -i processing
processing=0

# Read the file and extract coordinates
while IFS= read -r line; do
  # Debug: Print each line being processed
  #echo "Processing line: $line"
  line=$(echo "$line" | tr -d '\r' | xargs)

  if [[ "$line" == "NODE_COORD_SECTION" ]]; then
    processing=1
    #echo "Found NODE_COORD_SECTION. Starting to extract coordinates..."
    continue
  fi

  if [[ $processing -eq 1 ]]; then
    if [[ "$line" == "EOF" ]]; then
      echo "End of coordinate section reached."
      break
    fi

    # Debug: Show line considered for coordinates
    #echo "Line for coordinates: $line"

    # Extract the coordinates using awk
    coords=$(echo "$line" | awk '{print "[" $2 ", " $3 "]"}')
    coordinates+="$coords, "
  fi
done < "$file_name"

# Trim trailing comma and space
coordinates=${coordinates%, }

# Debug: Check the final coordinates
echo "$coordinates"
