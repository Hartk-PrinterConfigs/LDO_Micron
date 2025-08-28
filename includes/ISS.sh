#!/bin/bash

file_name="shaper_calibrate_"
current_time=$(date "+%Y-%m-%d-%H-%M-%S")

home/dietpi/klipper/scripts/calibrate_shaper.py /tmp/calibration_data_x_*.csv -o home/dietpi/printer_data/config/ISGraphs/X.png
home/dietpi/klipper/scripts/calibrate_shaper.py /tmp/calibration_data_y_*.csv -o home/dietpt/printer_data/config/ISGraphs/Y.png
rm /tmp/calibration_data_*.csv