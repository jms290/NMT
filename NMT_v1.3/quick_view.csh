#!/bin/tcsh
#quickly open AFNI and SUMA with the NMT surfaces
#
#example: tcsh quick_view.csh
#
#DO NOT MOVE THIS SCRIPT NMT directory
cd `dirname $0`

afni -dset NMT.nii.gz
suma -spec ./surfaces/NMT_both.spec -sv NMT.nii.gz &
