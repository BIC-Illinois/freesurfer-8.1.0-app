# freesurfer-8.1.0-app
Apptainer image for Freesurfer v8.1.0

## Build

```sh
apptainer build freesurfer-v8.1.0.sif freesurfer-v8.1.0.def
```

## Usage

```sh
apptainer run -B /path/to/your/data:/datain freesurfer-v8.1.0.sif <Freesurfer commands>
```
