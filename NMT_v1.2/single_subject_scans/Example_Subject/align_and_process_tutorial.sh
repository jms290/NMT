#!/bin/bash
#Lists the steps required to align and process single subject data using the NIMH Macaque Template.
#If you would just like the instruction output, run this command with the --dry option
##Example: bash align_and_process_example.sh --dry

echo "Here are the steps required to align and process your single subject scans using the NIMH Macaque Template:"
echo "	1) Change your current directory to Example_Subject/"
echo "		cd '$(dirname $0)'"
echo "	2) Align Single Subject Scan to the NIMH Macaque Template and align the D99 atlas to your single subject scan (Requires AFNI):"
echo "		tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT.nii.gz ../../D99_atlas_1.2a_al2NMT.nii.gz"
echo "	   If you would like to forgo aligning the D99 atlas, simply remove ../../D99_atlas_1.2a_al2NMT.nii.gz from the command:"
echo "		tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT.nii.gz"
echo "	   If your data is already skullstriped, use the skullstriped version of the NMT to align to (NMT_SS.nii.gz):"
echo "		tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT_SS.nii.gz"
echo "	3) Perform skull-striping and segmentation on you single subject dataset (Requires ANTs):"
echo "		bash ../../NMT_subject_process Example_Subject.nii.gz"
echo "	4) Estimate cortical thickness, surface area and curvature for single subject (Requires ANTs):"
echo "		bash ../../NMT_subject_morph Example_Subject.nii.gz"

if [ $1 == "--dry" ] 
then
	echo "Dry Run Enabled. No commands will run."
	dry=1
else
	echo "Script will now run above commands on our Example_Subject."
	dry=0
fi
echo "------------------------------------------------------------"
if [ $dry == 0 ] 
then
	echo "Here are the steps required to align and process your single subject scans using the NIMH Macaque Template:"
	echo "	1) Change your current directory to Example_Subject/"
	echo "		cd '$(dirname $0)'"
	cd "$(dirname $0)"

	echo "	2) Align Single Subject Scan to the NIMH Macaque Template and align the D99 atlas to your single subject scan"
	echo "		tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT.nii.gz ../../D99_atlas_1.2a_al2NMT.nii.gz"
	echo "	   If you would like to forgo aligning the D99 atlas, simply remove ../D99_atlas_1.2a_al2NMT.nii.gz from the command:"
	echo "		tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT.nii.gz"
	echo "	   If your data is already skullstriped, use the skullstriped version of the NMT to align to (NMT_SS.nii.gz):"
	echo "		tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT_SS.nii.gz"

	tcsh ../../NMT_subject_align.csh Example_Subject.nii.gz ../../NMT.nii.gz ../../D99_atlas_1.2a_al2NMT.nii.gz

	if [ -z ${ANTSPATH+x} ] 
	then
		echo "ANTSPATH could be found. While this will not affect NMT_subject_align.csh, "
		echo "both NMT_subject_morph and NMT_subject process require ANTs to be installed."
	else
		echo "	3) Perform skull-striping and segmentation on you single subject dataset:"
		echo "		bash ../../NMT_subject_process Example_Subject.nii.gz"
	
		bash ../../NMT_subject_process Example_Subject.nii.gz

		echo "	4) Estimate cortical thickness, surface area and curvature for single subject:"
		echo "		bash ../../NMT_subject_morph Example_Subject.nii.gz"
	
		bash ../../NMT_subject_morph Example_Subject.nii.gz
	fi
fi

