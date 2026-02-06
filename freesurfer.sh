#!/bin/bash
#
# Wrapper script for Freesurfer v8.1.0

# Apptainer run command
apptainer run /scratch/BICpipeline/apptainer_images/freesurfer-v8.1.0_wrapper.sif ${@}

