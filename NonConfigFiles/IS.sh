#!/bin/sh

file_name="shaper_calibrate_"
current_time=$(date "+%Y-%m-%d-%H-%M-%S")
graph_dir=~/printer_data/config/NonConfigFiles/ISGraphs
archive_dir="$graph_dir/Archive"

# --- Keep only the newest CSV per axis in /tmp, delete the rest ---
cleanup_and_get_latest() {
  axis="$1"

  # List files (may include both calibration and resonances)
  files=$(ls -t /tmp/calibration_data_"$axis"_*.csv /tmp/resonances_"$axis"_*.csv 2>/dev/null | head -n 20)

  [ -z "$files" ] && echo "" && return 1

  # First file in -t sort is newest
  newest=$(echo "$files" | head -n 1)

  # Delete all except newest
  echo "$files" | tail -n +2 | xargs -r rm -f --

  echo "$newest"
  return 0
}

# Prune CSVs first (do this before anything else)
x_file=$(cleanup_and_get_latest x || true)
y_file=$(cleanup_and_get_latest y || true)

# Ensure Archive directory exists
mkdir -p "$archive_dir"

# Move existing files (excluding Archive) to Archive
for file in "$graph_dir"/*; do
  if [ "$file" != "$archive_dir" ] && [ -f "$file" ]; then
    mv "$file" "$archive_dir"/
  fi
done

# X axis
if [ -n "$x_file" ] && [ -f "$x_file" ]; then
  echo "Using X file: $x_file"
  ~/klipper/scripts/calibrate_shaper.py "$x_file" -o "$graph_dir/${file_name}x_${current_time}.png"
else
  echo "No valid X-axis CSV file found."
fi

# Y axis
if [ -n "$y_file" ] && [ -f "$y_file" ]; then
  echo "Using Y file: $y_file"
  ~/klipper/scripts/calibrate_shaper.py "$y_file" -o "$graph_dir/${file_name}y_${current_time}.png"
else
  echo "No valid Y-axis CSV file found."
fi