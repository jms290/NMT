#!/bin/tcsh
#quickly open AFNI with the D99 atlas overlaid onto the NMT template
# and open SUMA with the NMT surfaces
#
#example: tcsh quick_view.csh

cd `dirname $0`
cd '../'

afni -com 'SWITCH_OVERLAY D99_atlas_1.2a_al2NMT.nii.gz'        \
	-com 'SWITCH_UNDERLAY NMT.nii.gz'                        \
	-com "SET_FUNC_AUTORANGE -"				\
	./
suma -spec ./surfaces/NMT_both.spec -sv NMT.nii.gz &
