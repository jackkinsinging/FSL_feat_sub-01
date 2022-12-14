#!/bin/bash


/bin/cp /tmp/feat_3cgsgjy_.fsf design.fsf
mkdir .files;cp /usr/local/fsl/doc/fsl.css .files;cp -r /usr/local/fsl/doc/images .files/images
/usr/local/fsl/bin/fsl_sub -T 10 -l logs -N feat0_init   /usr/local/fsl/bin/feat ./run1.feat/design.fsf -D ./run1.feat -I 1 -init
/usr/local/fsl/bin/fsl_sub -T 44 -l logs -N feat2_pre -j 5250  /usr/local/fsl/bin/feat ./run1.feat/design.fsf -D ./run1.feat -I 1 -prestats
/usr/local/fsl/bin/fsl_sub -T 1 -l logs -N feat5_stop -j 5529  /usr/local/fsl/bin/feat ./run1.feat/design.fsf -D ./run1.feat -stop

##Initialisation
/usr/local/fsl/bin/fslmaths ./func/sub-01_task-flanker_run-1_bold prefiltered_func_data -odt float
/usr/local/fsl/bin/fslroi prefiltered_func_data example_func 73 1

##Preprocessing:Stage 1
/usr/local/fsl/bin/mainfeatreg -F 6.00 -d ./run1.feat -l ./run1.feat/logs/feat2_pre -R ./run1.feat/report_unwarp.html -r ./run1.feat/report_reg.html  -i ./run1.feat/example_func.nii.gz  -h ./anat/sub-01_T1w_brain -w  12 -x 90 -s /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -y 12 -z 90 

##Registration
/bin/mkdir -p ./run1.feat/reg
/usr/local/fsl/bin/fslmaths ./anat/sub-01_T1w_brain highres
/usr/local/fsl/bin/fslmaths /usr/local/fsl/data/standard/MNI152_T1_2mm_brain standard
/usr/local/fsl/bin/flirt -in example_func -ref highres -out example_func2highres -omat example_func2highres.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 
/usr/local/fsl/bin/convert_xfm -inverse -omat highres2example_func.mat example_func2highres.mat
/usr/local/fsl/bin/slicer example_func2highres highres -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png ; /usr/local/fsl/bin/pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2highres1.png ; /usr/local/fsl/bin/slicer highres example_func2highres -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png ; /usr/local/fsl/bin/pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2highres2.png ; /usr/local/fsl/bin/pngappend example_func2highres1.png - example_func2highres2.png example_func2highres.png; /bin/rm -f sl?.png example_func2highres2.png
/bin/rm example_func2highres1.png
/usr/local/fsl/bin/flirt -in highres -ref standard -out highres2standard -omat highres2standard.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 
/usr/local/fsl/bin/convert_xfm -inverse -omat standard2highres.mat highres2standard.mat
/usr/local/fsl/bin/slicer highres2standard standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png ; /usr/local/fsl/bin/pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png highres2standard1.png ; /usr/local/fsl/bin/slicer standard highres2standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png ; /usr/local/fsl/bin/pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png highres2standard2.png ; /usr/local/fsl/bin/pngappend highres2standard1.png - highres2standard2.png highres2standard.png; /bin/rm -f sl?.png highres2standard2.png
/bin/rm highres2standard1.png
/usr/local/fsl/bin/convert_xfm -omat example_func2standard.mat -concat highres2standard.mat example_func2highres.mat
/usr/local/fsl/bin/flirt -ref standard -in example_func -out example_func2standard -applyxfm -init example_func2standard.mat -interp trilinear
/usr/local/fsl/bin/convert_xfm -inverse -omat standard2example_func.mat example_func2standard.mat
/usr/local/fsl/bin/slicer example_func2standard standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png ; /usr/local/fsl/bin/pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2standard1.png ; /usr/local/fsl/bin/slicer standard example_func2standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png ; /usr/local/fsl/bin/pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2standard2.png ; /usr/local/fsl/bin/pngappend example_func2standard1.png - example_func2standard2.png example_func2standard.png; /bin/rm -f sl?.png example_func2standard2.png

## Preprocessing:Stage 2
/usr/local/fsl/bin/mcflirt -in prefiltered_func_data -out prefiltered_func_data_mcf -mats -plots -reffile example_func -rmsrel -rmsabs -spline_final
/bin/mkdir -p mc ; /bin/mv -f prefiltered_func_data_mcf.mat prefiltered_func_data_mcf.par prefiltered_func_data_mcf_abs.rms prefiltered_func_data_mcf_abs_mean.rms prefiltered_func_data_mcf_rel.rms prefiltered_func_data_mcf_rel_mean.rms mc
/usr/local/fsl/bin/fsl_tsplot -i prefiltered_func_data_mcf.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 640 -h 144 -o rot.png 
/usr/local/fsl/bin/fsl_tsplot -i prefiltered_func_data_mcf.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 640 -h 144 -o trans.png 
/usr/local/fsl/bin/fsl_tsplot -i prefiltered_func_data_mcf_abs.rms,prefiltered_func_data_mcf_rel.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 640 -h 144 -a absolute,relative -o disp.png 
/usr/local/fsl/bin/fslmaths prefiltered_func_data_mcf -Tmean mean_func
/usr/local/fsl/bin/bet2 mean_func mask -f 0.3 -n -m; /usr/local/fsl/bin/immv mask_mask mask
/usr/local/fsl/bin/fslmaths prefiltered_func_data_mcf -mas mask prefiltered_func_data_bet
/usr/local/fsl/bin/fslstats prefiltered_func_data_bet -p 2 -p 98
/usr/local/fsl/bin/fslmaths prefiltered_func_data_bet -thr 85.2553772 -Tmin -bin mask -odt char
/usr/local/fsl/bin/fslstats prefiltered_func_data_mcf -k mask -p 50
/usr/local/fsl/bin/fslmaths mask -dilF mask
/usr/local/fsl/bin/fslmaths prefiltered_func_data_mcf -mas mask prefiltered_func_data_thresh
/usr/local/fsl/bin/fslmaths prefiltered_func_data_thresh -Tmean mean_func
/usr/local/fsl/bin/susan prefiltered_func_data_thresh 512.74932825 2.12314225053 3 1 1 mean_func 512.74932825 prefiltered_func_data_smooth
/usr/local/fsl/bin/fslmaths prefiltered_func_data_smooth -mas mask prefiltered_func_data_smooth
/usr/local/fsl/bin/fslmaths prefiltered_func_data_smooth -mul 14.6270303768 prefiltered_func_data_intnorm
/usr/local/fsl/bin/fslmaths prefiltered_func_data_intnorm -Tmean tempMean
/usr/local/fsl/bin/fslmaths prefiltered_func_data_intnorm -bptf 25.0 -1 -add tempMean prefiltered_func_data_tempfilt
/usr/local/fsl/bin/imrm tempMean
/usr/local/fsl/bin/fslmaths prefiltered_func_data_tempfilt filtered_func_data
/usr/local/fsl/bin/fslmaths filtered_func_data -Tmean mean_func
/bin/rm -rf prefiltered_func_data*