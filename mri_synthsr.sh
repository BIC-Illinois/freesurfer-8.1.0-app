#!/bin/bash
# This script is a wrapper for the SynthSR application within FreeSurfer (run via Apptainer)
#
# Usage: mri_synthsr.sh --i INPUT_SCAN --o OUTPUT_MPRAGE_NAME [--threads THREADS] [--cpu]

# Check that arguments are valid
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 --i INPUT_SCAN --o OUTPUT_MPRAGE_NAME [--threads THREADS] [--cpu]"
    exit 1
fi

INPUT_SCAN=""
OUTPUT_MPRAGE_NAME=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --i) INPUT_SCAN="$2"; shift ;;
        --o) OUTPUT_MPRAGE_NAME="$2"; shift ;;
        --threads) THREADS="$2"; shift ;;
        --cpu) CPU_FLAG="--cpu" ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Validate input parameters
if [ -z "$INPUT_SCAN" ] || [ -z "$OUTPUT_MPRAGE_NAME" ]; then
    echo "Error: Both --i and --o parameters are required."
    exit 1
fi

# Copy input image to current directory for processing
cp "$INPUT_SCAN" ./input_image.nii.gz
# Get output directory
OUTPUT_DIR=$(dirname "$OUTPUT_MPRAGE_NAME")

# Example Apptainer run command: apptainer run -B /path/to/your/data:/datain freesurfer-v8.1.0.sif mri_synthsr --i INPUT_SCAN --o OUTPUT_MPRAGE_NAME --threads THREADS --cpu

# Apptainer run command (binding current directory for data access)
apptainer run -B $(pwd):/data \
    freesurfer-v8.1.0.sif \
    mri_synthsr \
    --i /data/input_image.nii.gz \
    --o /data/synthsr_output.nii.gz \
    ${THREADS:+--threads $THREADS} \
    ${CPU_FLAG}

# Move output to desired location
mv ./synthsr_output.nii.gz "$OUTPUT_MPRAGE_NAME"
# Clean up temporary input file
rm ./input_image.nii.gz
echo "SynthSR processing complete. Output saved to $OUTPUT_MPRAGE_NAME"