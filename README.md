# freesurfer-8.1.0-app
Apptainer image for Freesurfer v8.1.0 (see [Release Notes](https://surfer.nmr.mgh.harvard.edu/fswiki/ReleaseNotes))

Freesurfer v8.0.0 and later contain a patched version of the [recon-all-clinical](https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all-clinical) script from v7.4.0.

Obtain a [Freesurfer license](https://surfer.nmr.mgh.harvard.edu/fswiki/License) if you do not yet have one from the 2025 calendar year. Place a copy of this file in this repository's folder.

Download a copy of the corrected [recon-all-clinical.sh script](https://github.com/freesurfer/freesurfer/blob/dev/recon_all_clinical/recon-all-clinical.sh) and place in this repository's folder.

## Build

```sh
apptainer build freesurfer-v8.1.0.sif freesurfer-v8.1.0.def
```

## Usage

### Basic:

```sh
apptainer run -B /path/to/your/data:/datain freesurfer-v8.1.0.sif <Freesurfer commands>
```

### Recon-all-clinical:

```sh
apptainer run -B /path/to/your/data:/datain freesurfer-v8.1.0.sif /usr/local/freesurfer/8.1.0/bin/recon-all-clinical.sh -i INPUT_SCAN -subjid -threads SUBJECT_ID THREADS [-sdir SUBJECT_DIR] [-ct]
```

- INPUT_SCAN: path to an image that will be processed.
- SUBJECT_ID: specifies the name or ID of the subject you would like to use. A directory with that name will be created for all the subject's FreeSurfer output.
- THREADS (optional): number of CPU threads to use. The default is just 1, so crank it up for faster processing if you have multiple cores!
- SUBJECT_DIR: only necessary if the environment variable SUBJECTS_DIR has not been set when sourcing FreeSurfer or if you want to override it.

#### Outputs:

This stream will create a directory structure that is almost the same as recon-all, but with some minor changes in the SUBJECT_DIR/mri:

- native.mgz: input (reconstructed) volume.
- synthseg.mgz: initial volumetric segmentation given by SynthSeg.
- aseg.auto_noCCseg.mgz: same as synthseg.mgz that is required for a number of subsequent processing steps of FreeSurfer.
- aseg.presurf.mgz: same as synthseg.mgz that is required for a number of subsequent processing steps of FreeSurfer.
- synthSR.raw.mgz: raw output of SynthSR.
- synthSR.norm.mgz: cleaned up version of synthSR.raw.mgz, scaled such that the white matter has intensity of 110.
- synthsurf.mgz: file with distance maps predicted by SynthDist.
- norm.mgz: generated intensity image with super-resolved cortex estimated from the distance maps in synthsurf.mgz. The subcortex of the brain is ignored here for placing surfaces.
- brain.mgz: same as norm.mgz that is required for a number of subsequent processing steps of FreeSurfer.
- brainmask.mgz: same as norm.mgz that is required for a number of subsequent processing steps of FreeSurfer.
- wm.mgz and wm.seg.mgz: these are volumetric white matter masks used to initialize the surface placement. 

Post completion of the cortical surface stream, some of the results from the cortical stream are used to refine the results in the directory SUBJECT_DIR/mri:
- aseg.mgz: this is the aseg with the refined cortex label from the placed surfaces.
- aparc*+aseg.mgz: same as aseg, but with parcellated cortical labels (according to 3 different atlases).
- *ribbon.mgz: the ribbon, given by the surfaces.
- synthSR.mgz: this is essentially synthSR.norm.mgz updated with the information from the cortical surfaces.
- wmparc.mgz: white matter parcellation. 
