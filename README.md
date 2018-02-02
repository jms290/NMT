# NMT - NIMH Macaque Template

For any issues or questions, contact Jakob Seidlitz at jakob.seidlitz@nih.gov or jms290@cam.ac.uk.

## Description
The NMT is an anatomical structural MRI template of the macaque brain. It was created using the freely available software package [ANTs](http://stnava.github.io/ANTs/). The NMT is technically the non-linear diffeomorphic average of 31 adult rhesus macaque brains, generated by iteratively registering and averaging each individual subject to a common space. For more information on the template creation process, see [our paper](http://www.sciencedirect.com/science/article/pii/S105381191730383X).

This README file provides an overview of the NMT MRI volume and its associated volume and surface files. Sample commands for visualizing the surfaces are listed as well, using [SUMA](https://afni.nimh.nih.gov/afni/suma) from the [AFNI](https://afni.nimh.nih.gov) software suite.

## Citation

If you use this repository, please cite the paper below:

Seidlitz, J., Sponheim, C., Glen, D., Ye, F.Q., Saleem, K.S., Leopold, D.A., Ungerleider, L., Messinger, A. A population MRI brain template and analysis tools for the macaque. *NeuroImage* (2017). doi: [10.1101/105874](http://www.sciencedirect.com/science/article/pii/S105381191730383X)

## Download

To download from the terminal, navigate to the directory where you want to store the NMT repository. Then, copy and paste this command:
```bash
git clone http://github.com/jms290/NMT.git
```

Otherwise, on the [NMT repository homepage](https://github.com/jms290/NMT), click the green button "clone or download"...

Alternatively, all files associated with the NMT may be downloaded straight from the AFNI website [here](https://afni.nimh.nih.gov/pub/dist/atlases/macaque/nmt/)


## NMT Files

All volume and surface files are stored in the relatively universal nifti (.nii.gz) and gifti (.gii) formats, to be compatible with a plethora of software packages.

- NMT volume (with skull) - **NMT.nii.gz**
- NMT volume (without skull) - **NMT_SS.nii.gz**
- NMT Masks
	- NMT brain mask
		+ NMT Binary Brainmask **NMT_brainmask.nii.gz**
		+ NMT Probabalistic Brainmask **NMT_brainmask_prob.nii.gz**
	- NMT probabilisitic tissue segmentation masks
		+ Gray matter - **NMT_segmentation_GM.nii.gz**
		+ White matter - **NMT_segmentation_WM.nii.gz**
		+ Cerebral spinal fluid - **NMT_segmentation_CSF.nii.gz**
	- NMT cortical gray matter mask - **NMT_GM_cortical_mask.nii.gz**
	- NMT cortical gray matter mask with white matter - **NMT_GM_cortical_mask_withWM.nii.gz**
	- NMT cortical cortical thickness mask - **NMT_CT.nii.gz**
	- NMT 4-tissue segmentation mask (including arterial blood vasculature) - **NMT_segmentation_4class.nii.gz**
	- NMT arterial blood vasculature - **NMT_blood_vasculature_mask.nii.gz**
	- NMT cerebellum - **NMT_cerebellum_mask.nii.gz**
	- NMT olfactory bulb - **NMT_olfactory_bulb_mask.nii.gz**
- NMT surfaces
	+ Gray matter surface - **[lh or rh].GM.gii**
	+ White matter surface - **[lh or rh].WM.gii**
	+ Mid-cortical surface - **[lh or rh].mid.gii**
	- NMT surfaces (inflated)
		+ Gray matter surface - **[lh or rh].GM_inflated.gii**
		+ White matter surface - **[lh or rh].WM_inflated.gii**
		+ Mid-cortical surface - **[lh or rh].mid_inflated.gii**
	- NMT surfaces (other)
		+ Arterial blood vasculature - **blood_vasculature.gii**
		+ Cerebellum surface - **cerebellum.gii**
- Common Atlases
	+ D99 Atlas Aligned to NMT - **D99_atlas_1.2a_al2NMT.nii.gz**
	+ F99 Transformation Parameters ([AFNI website](https://afni.nimh.nih.gov/pub/dist/atlases/macaque/nmt/NMT_v1.2/volumetric_transformations/))- **/F99_volumetric_transformations**

There is also a .spec file - **NMT_both.spec**, which is a text file used by SUMA to load in each of the left and right hemisphere surfaces above.

## Visualization in AFNI/SUMA

Navigate to the directory where you have stored the NMT repository. Then follow these steps:
```bash
afni -niml &
```
This will start AFNI and tell AFNI that a connection with SUMA is imminent. Load in NMT.nii.gz as the underlay if it is not loaded automatically. Then, back in the terminal, run:
```bash
suma -spec ./NMT_both.spec -sv ./NMT.nii.gz &
```
This should start SUMA, and you should see the left and right WM surfaces. To switch to a different set of surfaces, move your cursor into the SUMA window and toggle the "." key. For other navigational shortcuts and tools, see the [SUMA documentation](https://afni.nimh.nih.gov/sscc/staff/ziad/SUMA/SUMA_do1.htm).

Toggle the "t" key to open the connection between AFNI and SUMA. You should see various outlines on the NMT volume in AFNI that correspond with the surfaces loaded into SUMA. To edit or remove the outlines in AFNI, toggle the "Control Surface" button in the AFNI GUI.

Now that AFNI and SUMA are linked, this will allow you to visualize any data (i.e. overlay) from the NMT volume on the surface. Note that only the voxels which intersect the surface outlines will be plotted on the surface. As such, we suggest using the "mid" surface for the visualization of any functional MRI data. For more information about using AFNI interactively, see this [slide show](https://afni.nimh.nih.gov/pub/dist/edu/latest/afni_handouts/afni03_interactive.pdf).

## Atlases in the NMT

We provide the D99 atlas nonlinearly warped to the NMT. Atlases may be further warped to the single subject space (see Single-Subject Processing) or utilized in the NMT for ROI-based analyses. Use of the D99 atlas should be accompanied with the following citation:

	Three-dimensional digital template atlas of the macaque brain
	Reveley, Gruslys, Ye, Glen, Samaha, Russ, Saad, Seth, Leopold, Saleem
	Cerebral Cortex, Aug 2016.

Furthermore, we include the rigid, affine, and diffeomorphic (non-linear) tranformations to the NMT from the F99 template [here](https://afni.nimh.nih.gov/pub/dist/atlases/macaque/nmt/NMT_v1.2/volumetric_transformations/). An example command to align the F99 atlas to the NMT (using AFNI's [3dNwarpApply](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dNwarpApply.html) command) is provided below:

```bash
3dNwarpApply -nwarp 'Macaque.F99UA1.LR.03-11_SurfVol_shft.1D \
 Macaque.F99UA1.LR.03-11_SurfVol_shft_al2std_mat.aff12.1D \
 Macaque.F99UA1.LR.03-11_SurfVol_shft_WARP.nii.gz' \
 -source {F99_atlas_name}  -ainterp NN -short \
 -master NMT.nii.gz -prefix F99_atlas_al2NMT.nii.gz
```

To go from the NMT to the D99 simply reverse the order of the transformations and add the INV() to each transformation file:

```bash
3dNwarpApply -nwarp 'INV(Macaque.F99UA1.LR.03-11_SurfVol_shft_WARP.nii.gz) \
INV(Macaque.F99UA1.LR.03-11_SurfVol_shft_al2std_mat.aff12.1D) \
INV(Macaque.F99UA1.LR.03-11_SurfVol_shft.1D)' \
-source NMT.nii.gz -ainterp NN -short \
-master {F99_atlas_name} -prefix NMT_in_F99_atlas.nii.gz
```

## Single-Subject Processing

Along with the NMT dataset, we provide scripts to automated the processing of single subjects.
See the [paper](http://www.sciencedirect.com/science/article/pii/S105381191730383X) as well as the table in the [supplemental material](https://ars.els-cdn.com/content/image/1-s2.0-S105381191730383X-mmc1.docx) for more information. Below is the usage for each script.

***-Only a reconstructed T1-weighted scan/volume is needed (either AFNI .BRIK/.HEAD or Nifti .nii or .nii.gz format)***

### NMT_subject_align
The **NMT_subject_align script** generates the rigid (6 parameter), affine (12 parameter), and non-linear (voxelwise) transformations to and from the NMT. The **NMT_subject_process** and **NMT_subject_morph** scripts depend on these transformations.
#### Usage
Create a directory where the NMT distribution is stored, and copy the scans of the individual subjects into this new directory. Run this script using a single scan as input, along with the NMT and NMT_subject_align.csh in the parent directory, as below:
```tcsh
tcsh ../NMT_subject_align.csh [subject] ../NMT.nii.gz
```
If the brain has already been masked out from your subject (i.e., skull-stripped), utilize the skull-stripped version of the NMT (NMT_SS.nii.gz) as input to NMT_subject_align, as below:

```tcsh
tcsh ../NMT_subject_align.csh [subject_without_skull] ../NMT.nii.gz
```

We also provide the ability to automate the alignment of atlases through NMT_subject_align:
```tcsh
tcsh ../NMT_subject_align.csh [subject] ../NMT.nii.gz ./D99_atlas_1.2a_al2NMT.nii.gz
```

NMT_subject_align provides multiple outputs to assist in registering your anatomicals and associated MRI data to the NMT:
- Subject scan registered to the NMT
	+ **mydset_shft+orig** - dataset center aligned to the NMT center
	+ **mydset_shft_al2std+orig** - dataset affine aligned to the NMT
	+ **mydset_shft_aff+orig** - dataset affine aligned to the NMT and on the NMT grid
	+ **mydset_warp2std.nii.gz** - dataset nonlinearly warped to the NMT
- Registration parameters for Alignment to NMT
	+ **mydset_shft.1D** - transformation matrix for shift to align echo center of dataset to center of the NMT
	+ **mydset_shft_al2std_mat.aff12.1D** - transformation matrix for affine transformation of dset to the NMT
	+ **mydset_shft_WARP.nii.gz** - warp deformations to the NMT from nonlinear alignment only
	+ **mydset_composite_linear_to_NMT.1D** - combined linear transformations to the NMT
	+ **mydset_composite_WARP_to_NMT.nii.gz** - combined linear and nonlinear transformations to the NMT
- Registration parameters for NMT Alignment to Subject
	+ **mydset_shft_inv.1D** - inverse of mydset_shft.1D
	+ **mydset_shft_inv_al2std_mat.aff12.1D** - inverse of mydset_shft_al2std_mat.aff12.1D
	+ **mydset_shft_WARPINV.nii.gz** - inverse of mydset_shft_WARP.nii.gz
	+ **mydset_composite_linear_to_NMT_inv.1D** - inverse of mydset_composite_linear_to_NMT.1D
	+ **mydset_composite_WARP_to_NMT_inv.nii.gz** - inverse of mydset_composite_WARP_to_NMT.nii.gz
- Brain Atlas Aligned to Single Subject (Optional)
	+ **{atlas}_in_mydset.nii.gz** - D99 Atlas Aligned to Single Subject

***-NOTE: NMT_subject_align requires the AFNI software package to run correctly***

Data aligned to your dataset can be easily warped to the NMT using NMT_subject_align outputs and AFNI's 3dNwarpApply:
```tcsh
3dNwarpApply -nwarp {mydset}_composite_WARP_to_NMT.nii.gz -source {newdset}+orig \
-master ../NMT.nii.gz -prefix {newdset}_in_NMT.nii.gz
```

For linear alignment to the NMT, please use AFNI's [3dAllineate](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dAllineate.html) command:
```tcsh
3dAllineate -1Dmatrix_apply {mydset}_composite_linear_to_NMT.1D -source {newdset}+orig \
-master ../NMT.nii.gz -prefix {newdset}_in_NMT.nii.gz
```

To bring data from the NMT to your dataset, simply use the inverse transformations of the above commands:
```tcsh
3dNwarpApply -nwarp {mydset}_composite_WARP_to_NMT_inv.nii.gz -source {newdset}+orig \
-master {mydset}+orig -prefix {NMTdset}_in_{mydset}.nii.gz
```
```tcsh
3dAllineate -1Dmatrix_apply {mydset}_composite_linear_to_NMT_inv.1D -source {newdset}+orig \
-master {mydset}+orig -prefix {NMTdset}_in_{mydset}.nii.gz
```

When warping atlas or mask data, add the -interp NN flag to avoid warping artifacts:
```tcsh
3dNwarpApply -nwarp {mydset}_composite_WARP_to_NMT_inv.nii.gz -source {NMTdset}+orig \
-master {mydset}+orig -prefix {NMTdset}_in_{mydset}.nii.gz -interp NN
```
```tcsh
3dAllineate -1Dmatrix_apply {mydset}_composite_linear_to_NMT_inv.1D -source {NMTdset}+orig \
-master .{mydset}+orig -prefix {NMTdset}_in_{mydset}.nii.gz -interp NN
```

### NMT_subject_process
**NMT_subject_process** performs N4 bias field correction for normalizing intensity non-uniformities, and generates a brain mask (for skull-stripping) as well as probabilistic tissue segmentation masks (GM, WM, CSF).
#### Usage
```bash
bash ../NMT_subject_process [subject]
```

Run this script from the directory where the NMT_subject_align output lies. This script will create a directory NMT_[subject]_process with the corresponding masks in the subject's anatomical space.

***-NOTE: NMT_subject_process requires AFNI and [ANTs](http://stnava.github.io/ANTs/) to be installed***

### NMT_subject_morph
**NMT_subject_morph** uses the NMT's cortical GM mask to produce volumetric maps of cortical thickness, surface area, and mean and gaussian (i.e., intrinsic) curvature.
#### Usage
```bash
bash ../NMT_subject_morph [subject]
```

Run this script from the directory where the NMT_subject_align output lies. This script will create a directory NMT_[subject]_morph with the corresponding masks in the subject's anatomical space.

***-NOTE: NMT_subject_morph requires AFNI and [ANTs](http://stnava.github.io/ANTs/) to be installed***

## Troubleshooting

#### NMT_subject_process results in a inaccurately fit brainmask
In cases when NMT_subject_process does not produce a sufficient brainmask, we recommend manually warping the NMT's brainmask to your subject using the AFNI's [3dNwarpApply](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dNwarpApply.html) command:
```tcsh
3dNwarpApply -nwarp {mydset}_composite_WARP_to_NMT_inv.nii.gz -source ../NMT_brainmask.nii.gz \
-master {mydset}+orig -prefix NMTbrainmask_in_{mydset}.nii.gz -interp NN
```
