#!/bin/bash

file_name="shaper_calibrate_"
current_time=$(date "+%Y-%m-%d-%H-%M-%S")
graph_dir=~/printer_data/config/NonConfigFiles/ISGraphs
archive_dir="$graph_dir/Archive"

# Ensure Archive directory exists
mkdir -p "$archive_dir"

# Move existing files (excluding Archive) to Archive
for file in "$graph_dir"/*; do
  if [ "$file" != "$archive_dir" ] && [ -f "$file" ]; then
    mv "$file" "$archive_dir"/
  fi
done

# Function to get CSV for axis
get_file_for_axis() {
  axis=$1
  for f in /tmp/calibration_data_"$axis"_*.csv /tmp/resonances_"$axis"_*.csv; do
    if [ -f "$f" ]; then
      echo "$f"
      return
    fi
  done
}

# X axis
x_file=$(get_file_for_axis x)
if [ -f "$x_file" ]; then
  echo "Using X file: $x_file"
  ~/klipper/scripts/calibrate_shaper.py "$x_file" -o "$graph_dir/${file_name}x_${current_time}.png"
else
  echo "No valid X-axis CSV file found."
fi

# Y axis
y_file=$(get_file_for_axis y)
if [ -f "$y_file" ]; then
  echo "Using Y file: $y_file"
  ~/klipper/scripts/calibrate_shaper.py "$y_file" -o "$graph_dir/${file_name}y_${current_time}.png"
else
  echo "No valid Y-axis CSV file found."
fi


