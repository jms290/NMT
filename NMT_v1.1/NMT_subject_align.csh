#!/bin/tcsh
# affine alignment of individual dataset to D99/NMT/any template
#
# usage:
#    NMT_subject_align.csh dset template_dset [segmentation_dset]
#
# example:
#    tcsh -x NMT_subject_align.csh Puffin_3mar11_MDEFT_500um+orig
#
set atlas_dir = "../.."
if ("$#" <  "2") then
   echo "usage:"
   echo "   NMT_subject_align.csh dset template_dset segmentation_dset segment_right_only_dset"
   echo
   echo "example:"
   echo " tcsh NMT_subject_align.csh macaque1+orig \"
   echo "   ${atlas_dir}/NMT_template_1.0.nii.gz \"
   echo
   echo "Note only the dset and template_dset are required. If no segmentation"
   echo "is given, then only the alignment steps are performed."
   echo
   echo "This program produces several kinds of output:"
   echo "    mydset_warp2std.nii.gz - dataset warped to the template"
   echo "    mydset_shft_WARP.nii.gz - warp deformations to template from nonlinear"
   echo "        alignment only"
   echo "    mydset_shft_WARPINV.nii.gz - inverse warp deformations to template"
   echo "    template_in_mydset_native+orig -  template transformed to native dataset"
   echo "        space"
   echo "    mydset_shft_al2std+tlrc - dataset only affinely aligned to template"
   echo "    mydset_shft_aff+tlrc - dataset only affinely aligned to template and on"
   echo "        template grid"
   echo "    template_in_mydset_aniso+tlrc - anisotropically smoothed template"
   echo "        transformed to native space"
   echo "    template_in_mydset_aniso_clust+tlrc - single cluster version of template"
   echo "        for surfaces in native space"
   echo "    mydset_shft_al2std_mat.aff12.1D - affine transformation of dset to template,"
   echo "        1D text file"
   echo "    mydset_shft_inv_.aff12.1D - inverse of affine transformation above"
   echo "    mydset_shft.1D - translation affine transformation for shift to align"
   echo "        center of dataset to center of template,1D text file"
   echo "    test_inv_shft.1D - inverse of translation shift above"
   echo "    template_in_mydset_aniso.gii - surface of template in native space"
   echo "    awpy_mydset - directory of nonlinear warp only output"
   echo "    surfaces - directory of surfaces for atlas segmentation regions"
   echo "    right_surfaces - directory of surfaces for right side only"
   echo
   echo " Here all occurrences of mydset in the output file names would be replaced"
   echo "    with the name of your dataset"
   exit
endif

setenv AFNI_COMPRESSOR GZIP

set dset = $1
set base = $2
if ("$#" < "3") then
   set segset = ""
else
   set segset = $3
endif

if ("$#" >=  "4") then
   set rightseg = $4
else
   set rightseg = ""
endif


# optional resample to template resolution and use that
# set finalmaster = `@GetAfniPrefix $base`
set finalmaster = $dset

# set dset = Puffin_3mar11_MDEFT_500um+orig
# set base = atlasdir/D99s_template+tlrc.
# set segset = atlasdir/D99_atlas+tlrc
# set rightseg = atlasdir/D99_atlas_right+tlrc

# get the non-NIFTI name out, dset+orig, dset.nii, dset.nii.gz all -> 'dset'
set dsetprefix = `@GetAfniPrefix $dset`
set dsetprefix = `basename $dsetprefix .gz`
set dsetprefix = `basename $dsetprefix .nii`

# which afni view is used even if NIFTI dataset is used as base
# usually +tlrc
set baseview = `3dinfo -av_space $base`

# this fails for AFNI format, but that's okay!
3dcopy $dset $dsetprefix
# get just the first occurrence if both +orig, +tlrc
set dset = ( $dsetprefix+*.HEAD )
set dset = $dset[1]

set origdsetprefix = $dsetprefix
if ($segset != "") then
   set segsetprefix = `@GetAfniPrefix $segset`
   set segsetdir = `dirname $segset`
endif

# put the center of the dataset on top of the center of the template
@Align_Centers -base $base -dset $dset

# keep a copy of the inverse translation too 
# (should just be negation of translation column)
cat_matvec ${dsetprefix}_shft.1D -I > ${dsetprefix}_inv_shft.1D

set origview = `@GetAfniView $dset`
set dset = ${dsetprefix}_shft${origview}
set dsetprefix = `@GetAfniPrefix $dset`

# figure out short name for template to insert into output files
echo $base |grep D99
if ($status == 0) then
   set templatename = D99
else
   echo $base | grep NMT
   if ($status == 0) then
      set templatename = NMT
   else
      set templatename = template
   endif
endif
 
# goto apply_warps

# do affine alignment with lpa cost
# using dset as dset2 input and the base as dset1 
# (the base and source are treated differently 
# by align_epi_anats resampling and by 3dAllineate)
align_epi_anat.py -dset2 $dset -dset1 $base -overwrite -dset2to1 \
    -giant_move -suffix _al2std -dset1_strip None -dset2_strip None
#
## put affine aligned data on template grid
# similar to al2std dataset but with exactly same grid
3dAllineate -1Dmatrix_apply ${dsetprefix}_al2std_mat.aff12.1D \
    -prefix ${dsetprefix}_aff -base $base -master BASE         \
    -source $dset -overwrite

# affinely align to template 
#  (could let auto_warp.py hande this, but AUTO_CENTER option might be needed)
# @auto_tlrc -base $base -input $dset -no_ss -init_xform AUTO_CENTER

# !!! Now skipping cheap skullstripping !!!
#   didn't work for macaques with very different size brains. V1 got cut off
#   probably could work with dilated mask
# "cheap" skullstripping with affine registered dataset
#  the macaque brains are similar enough that the affine seems to be sufficient here
#  for skullstripping
# 3dcalc -a ${dsetprefix}_aff+tlrc. -b $base -expr 'a*step(b)'   \
#    -prefix ${dsetprefix}_aff_ns -overwrite


# nonlinear alignment of affine skullstripped dataset to template
#  by default,the warp and the warped dataset are computed
#  by using "-qw_opts ", one could save the inverse warp and do extra padding
#  with -qw_opts '-iwarp -expad 30'
# change qw_opts to remove max_lev 2 for final   ********************
rm -rf awpy_${dsetprefix}
auto_warp.py -base $base -affine_input_xmat ID -qworkhard 0 2 \
   -input ${dsetprefix}_aff${baseview} -overwrite \
   -output_dir awpy_${dsetprefix} -qw_opts -iwarp


apply_warps:
# the awpy has the result dataset, copy the warped data, the warp, inverse warp
# don´t copy the warped dataset - combine the transformations instead below
# cp awpy_${dsetprefix}/${dsetprefix}_aff.aw.nii ./${dsetprefix}_warp2std.nii
cp awpy_${dsetprefix}/anat.un.qw_WARP.nii ${dsetprefix}_WARP.nii
cp awpy_${dsetprefix}/anat.un.qw_WARPINV.nii ${dsetprefix}_WARPINV.nii

# if the datasets are compressed, then copy those instead
# note - not using the autowarped dataset, just the WARP
#  see 3dNwarpApply just below
# cp awpy_${dsetprefix}/${dsetprefix}_aff.aw.nii.gz ./${dsetprefix}_warp2std.nii.gz
cp awpy_${dsetprefix}/anat.un.qw_WARP.nii.gz  ./${dsetprefix}_WARP.nii.gz

# compress these copies (if not already compressed)
# gzip -f ${dsetprefix}_warp2std.nii ${dsetprefix}_WARP.nii
gzip -f ${dsetprefix}_WARP.nii ${dsetprefix}_WARPINV.nii

# combine nonlinear and affine warps for dataset warped to standard template space
#   **** mod - DRG 07 Nov 2016
3dNwarpApply -prefix ${origdsetprefix}_warp2std.nii.gz                      \
   -nwarp "${dsetprefix}_WARP.nii.gz ${dsetprefix}_al2std_mat.aff12.1D" \
   -source $dset -master $base

# compute the inverse of the affine alignment transformation - all 12 numbers
#  on one line
cat_matvec -ONELINE ${dsetprefix}_al2std_mat.aff12.1D -I >! ${dsetprefix}_inv.aff12.1D
# also a 3 line version
cat_matvec ${dsetprefix}_al2std_mat.aff12.1D -I >! ${dsetprefix}_inv_al2std_mat.aff12.1D

# warp segmentation from atlas back to the original macaque space 
#  of the input dataset (compose overall warp when applying)
#  note - if transforming other datasets like the template
#    back to the same native space, it will be faster to compose
#    the warp separately with 3dNwarpCat or 3dNwarpCalc rather
#    than composing it for each 3dNwarpApply
if ($segset != "") then
   3dNwarpApply -ainterp NN -short -overwrite -nwarp \
      "${dsetprefix}_inv.aff12.1D INV(${dsetprefix}_WARP.nii.gz)"  -overwrite \
      -source $segset -master ${dsetprefix}${origview} -prefix __tmp_${dsetprefix}_seg
   # put back in non-shifted version (really native space) 
   @Align_Centers -base ${finalmaster} -dset  __tmp_${dsetprefix}_seg${origview}. -no_cp

   # change the datum type to byte to save space
   # this step also gets rid of the shift transform in the header
   3dcalc -a __tmp_${dsetprefix}_seg${origview} -expr a -datum byte -nscale \
      -overwrite -prefix ${origdsetprefix}_seg

   # copy segmentation information from atlas to this native-space
   #   segmentation dataset and mark to be shown with integer colormap
   3drefit -cmap INT_CMAP ${origdsetprefix}_seg${origview}
   3drefit -copytables $segset ${origdsetprefix}_seg${origview}
endif




# create transformed template in this macaque's native space
# this dataset is useful for visualization
3dNwarpApply -overwrite -short -nwarp "${dsetprefix}_inv.aff12.1D INV(${dsetprefix}_WARP.nii.gz)" \
   -source $base -master ${dsetprefix}${origview} -prefix __tmp_${templatename}_in_${dsetprefix}_native -overwrite
@Align_Centers -base ${finalmaster} -dset __tmp_${templatename}_in_${dsetprefix}_native${origview} -no_cp
# change the datum type to byte to save space
# this step also gets rid of the shift transform in the header
3dcalc -a __tmp_${templatename}_in_${dsetprefix}_native${origview} -expr a -datum byte -nscale \
   -prefix ${templatename}_in_${origdsetprefix}_native -overwrite


# Warp the right side of the atlas separately
# easier than figuring out right from left in native space directly
if ($rightseg != "") then
   3dNwarpApply -ainterp NN -short -overwrite -nwarp \
      "${dsetprefix}_inv.aff12.1D INV(${dsetprefix}_WARP.nii.gz)"  -overwrite \
      -source ${rightseg} -master ${dsetprefix}${origview} -prefix __tmp_${dsetprefix}_right_seg

   # put back in non-shifted version (really native space) 
   @Align_Centers -base ${finalmaster} -dset  __tmp_${dsetprefix}_right_seg${origview} -no_cp

   # change the datum type to byte to save space
   # this step also gets rid of the shift transform in the header
   3dcalc -a __tmp_${dsetprefix}_right_seg${origview} -expr a -datum byte -nscale \
      -overwrite -prefix ${origdsetprefix}_right_seg  -overwrite

   # copy segmentation information from atlas to this native-space
   #   segmentation dataset and mark to be shown with integer colormap
   3drefit -cmap INT_CMAP ${origdsetprefix}_right_seg${origview}
   3drefit -copytables $segset ${origdsetprefix}_right_seg${origview}
   mkdir right_surfaces
   cd right_surfaces
   IsoSurface -isorois+dsets -o native.gii -input ../${origdsetprefix}_right_seg${origview} -noxform \
      -Tsmooth 0.1 100 -remesh 0.1
   cd ..
endif 

if ($segset != "") then
   # create surfaces for all regions in atlas, but now in native space
   mkdir surfaces
   cd surfaces
   IsoSurface -isorois+dsets -o native.gii -input ../${origdsetprefix}_seg${origview} -noxform \
      -Tsmooth 0.1 100 -remesh 0.1
   cd ..
endif

# "carve" out template (D99,NMT,...) surface in native space to use as representative surface
#  using anisotropic smoothing
# could use skullstripped original instead
3danisosmooth -prefix ${templatename}_in_${origdsetprefix}_aniso -3D -iters 6 \
   -matchorig ${templatename}_in_${origdsetprefix}_native${origview}
# also remove any  small clusters for surface generation (threshold here is specific so may need tweaking)
3dclust -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -57.2 57.2 \
   -savemask ${templatename}_in_${origdsetprefix}_aniso_clust -dxyz=1 1.01 20000 \
   ${templatename}_in_${origdsetprefix}_aniso${origview}
IsoSurface -isorange 1 255 -overwrite -input ${templatename}_in_${origdsetprefix}_aniso_clust${origview} \
   -o  ${templatename}_in_${origdsetprefix}_aniso.gii -overwrite -noxform -Tsmooth 0.1 20

echo "Dataset output:"
echo "   segmentation in native space:  ${origdsetprefix}_seg+orig"
echo "   base template in native space: ${templatename}_in_${origdsetprefix}+orig"
echo "   surfaces in native space in surfaces directory"
echo "   right-side surfaces in native space in right_surfaces directory"
echo   
echo "to show surfaces in suma, use a command like this:"
echo "    suma -onestate -i surfaces/native*.gii -vol ${origdsetprefix}${origview} -sv  ${templatename}_in_${origdsetprefix}_native${origview}"
echo "or to show the template transformed to native space, use this:"
echo "    suma -onestate -i surfaces/native*.gii -vol ${origdsetprefix}${origview} -sv  ${templatename}_in_${origdsetprefix}_native${origview}"
echo
echo "or show template as a *surface* in native space with segmentation volume, use this command"
echo "    suma -onestate -anatomical -i  ${templatename}_in_${origdsetprefix}_aniso.gii -vol ${origdsetprefix}_seg${origview}  -sv ${origdsetprefix}_seg${origview}"
echo


# get rid of temporary warped datasets
rm __tmp*_${dsetprefix}*.HEAD __tmp*_${dsetprefix}*.BRIK* __tmp*_${dsetprefix}*.1D

# notes

# warp the transformed macaque back to its original space
#  just as a quality control. The two datasets should be very similar
# 3dNwarpApply -overwrite -short -nwarp \
#   "${dsetprefix}_inv.aff12.1D INV(${dsetprefix}_WARP.nii.gz)" \
#   -source ${dsetprefix}_warp2std.nii.gz -master ${finalmaster}+orig \
#   -prefix ${dsetprefix}_iwarpback -overwrite


# zeropad the warp if segmentation doesn't cover the brain and reapply the warp
# 3dZeropad -S 50 -prefix ${dsetprefix}_zp_WARP.nii.gz ${dsetprefix}_WARP.nii.gz
# 3dNwarpApply -interp NN \
#   -nwarp "${dsetprefix}_inv.aff12.1D INV(${dsetprefix}_zp_WARP.nii.gz)" \
#   -source $segset -master $dset -prefix ${dsetprefix}_seg_zp
# 3drefit -cmap INT_CMAP ${dsetprefix}_seg_zp+orig
# 3drefit -copytables $segset ${dsetprefix}_seg_zp+orig
