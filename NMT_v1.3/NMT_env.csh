#!/bin/tcsh
# set environment variables in AFNI's .afnirc file in the user's home directory
# either run this script from the AFNI_scripts directory or change the ANI_SUPP_ATLAS_DIR
# variable location
# DO NOT MOVE THIS SCRIPT.
# Adapted from macaque_env.csh found with the D99 macaque template
#usage : tcsh NMT_env.csh

cd `dirname $0`
set session = $PWD
@AfniEnv -set AFNI_SUPP_ATLAS_DIR $session
@AfniEnv -set AFNI_WHEREAMI_DEC_PLACES 2
@AfniEnv -set AFNI_ATLAS_COLORS D99_atlas
@AfniEnv -set AFNI_TEMPLATE_SPACE_LIST NMT
@AfniEnv -set AFNI_WEBBY_WAMI YES
