# freesurfer-8.1.0-app
Apptainer image for Freesurfer v8.1.0

Obtain a [Freesurfer license](https://surfer.nmr.mgh.harvard.edu/fswiki/License) if you do not yet have one from the 2025 calendar year. Place a copy of this file in this repository's folder.

## Build

```sh
apptainer build freesurfer-v8.1.0.sif freesurfer-v8.1.0.def
```

## Usage

```sh
apptainer run -B /path/to/your/data:/datain freesurfer-v8.1.0.sif <Freesurfer commands>
```
