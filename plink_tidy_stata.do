//20201105 9th version - test with TWB1
// Step 2. Plink Steps

clear all
macro drop _all


// set working directory
cd "E:\Data\Gene\trial11_20201130"

// set path for plink
global plinkpath "D:\User_Data\Desktop\gene\plink\plink.exe"
global plink2path "D:\User_Data\Desktop\gene\plink2\plink2.exe"

// set data path
// global data "C:\Data\TWBioBank\combined_TWB1_TWB2\combined.TWB1.TWB2.high.confidence.v1"
global data "E:\Data\Gene\trial11_20201130\00_small_sample_combined"

global datatype "imputation"  /*"imputation" or "", skips QC steps 4 & 5 if enter "imputation"*/

/*
global merged_survey "D:\User_Data\Desktop\基因\questionnaires\stata clean survey data\twbiobank_merged_20201109"  

global do01 "E:\Data\Gene\trial11_20201130\01_plink survey data input_20201202"
run "${do01}" /*select individuals*/
*/

// --------------------------------------------------------------------------------
global filename = ""
local loc = strpos("$data", "TWB1")
if `loc'!=0{
    global filename = "TWB1_"
}
local loc = strpos("$data", "TWB2")
if `loc'!=0{
    global filename = "TWB2_"
}
local loc = strpos("$data", "combined")
if `loc'!=0{
    global filename = "TWB1+2_"
}

if "$datatype"=="imputation"{
    global filename = "${filename}imp_"
}
//---------------------------------------------------------------------------------
// start from certain step, options include "" and elements in `steps'
global start_from "pca" /*if "", detects whether files exist and start from latest step*/

local steps = "QC1_maf QC2_miss QC3_bi QC4_sex QC5_chrom QC6_hwe QC7_het QC9_relate pca QC0_keep gwas clump prs recode"

global nstart_from .
local ct 0
foreach i of local steps{
	local ++ct
	if "`i'"=="${start_from}"{
		global nstart_from `ct'	
	}
}
//---------------------------------------------------------------------------------
// set QC thresholds
global setmaf = 0.01      /*set minor allele frequency*/
global setgeno = 0.05     /*set genotype missingness*/
global setmind = 0.05     /*set individual missingness*/
global setking = 0.066    /*set individual relatedness*/
						  /*first-degree relations: 0.177; second-degree: 0.088; third-degree: 0.044; */
						  /*between second & third: 0.066*/
global setwindow = 500    /*set pruning window*/
global setstep = 5        /*set pruning step size*/
global setr2 = 0.2        /*set pruning R2*/
global setclumpr2 = 0.5   /*set clumping R2*/
global setclumpkb = 250   /*set clumping distance in kilobase*/

// set number of principal components
global pcs 10

// set phenotypes
global phenos "eduyrs lbody_height BODY_HEIGHT BMI"
global phenos "eduyrs"

// set significant levels (p-values) for clumping
global siglevel_list "0.00000005 0.000001"
global siglevel_list "0.00000005"

// set sex
global sex "_m _f _a" /*f for female, m for male, a for all*/
global sex "_a"

// set conditions
global condition "AGE<=55"  /*if XXX, no need to enter sex, will generate 3 files (male, female, all)*/

qui{
#delimit;
global vars "
NASOPHARYNGEAL_CAN_SELF
HOMO_6_YRS
CANCER_OTHER_SELF
HERBAL_4
HB_Ref_1
G_5_d
SUPP_C_FREQ
FEF50
SGPT
G_5
EYE_DIS_OTHER_1_L
COLORECTAL_CANCER_BRO
VC
HYPERTENSION
TEA_B_UNIT
HOMO_3_YRS
DYS
TG_Ref_1
OVACAN_SELF
SMK_2ND_PLACE3_HRS
CANCER_OTHER_MOM
F_SUPP
D_5
ARTHRITIS_BRO
INCENSE_C_HURS
F_NO_DISEASE
NATIVE_MOM_CHINA
HEADACHE_AND_HEMICRANIA
SLEEP_QUALITY
SPO_NOTE
ENDO_SIS
D_6
WET_HVY
COOK_TIMES
NUT_CURR
LIVER_CANCER_SIS_P
HBSAG_2
KIDNEY_STONE_MOM
Draw_Time
SUPP_A_DOSAGE
CERVICAL_P_SELF
I_6
DRUG_B_OTHER
DYS_SELF
FID
CERVICAL_P_MOM
I_2
VEGE_KIND
SUPP_E_FREQ
APOPLEXIA_BRO_P
FLOATERS_R
inc_self_mid
LIVER_CANCER_FA
CORONARY_ARTERY_DIS_FA
JOB_LGST_POSITION
WATER_ORIGIN_YRS
HERBAL_4_MONTHS
COFFEE
SPO_HABIT_C_HRS
HEMICRANIA_BRO
AGE_MATCHED
JOB_CURR
WET_CONTROL3
G_5_a
DRK_QUIT_MONTHS
DRUG_NAME_E
ALLERGIC
OCD_SELF_MONTH
F_SUPP_2_MONTHS
SPO_ANY_A_FREQ
CONGENITAL_HEART_DIS_SIS_P
HERBAL_1_YRS
DEMENTIA_SELF_YEAR
SGOT_Ref_1
APOPLEXIA_SELF_YEAR
DRK_QUIT_A_TIMES
DRK_QUIT_B_TIMES
SCHIZOPHRENIA_FA
HOMO_4
DRK_CURR_C_UNIT
ARRHYTHMIA_BRO
ANTI_HBS_AB_2
DEPRESSION
OVA_MOM
KIDNEY_STONE_SIS_P
ARTICULUS_ACHE
LUNG_FUNCTION_NOTE
ASTHMA_BRO_P
CONGENITAL_HEART_DIS_BRO
PEPTIC_ULCER_SELF_YEAR
JOB_LGST_WEEKLY_HRS
T_CHO_Ref_1
ALLERGIC_SELF_MONTH
F_SUPP_2_YRS
OVA_SELF_MONTH
DRK_QUIT_A_FREQ
SLEEP_D_TIME
D_8
DRUG_A_TIMES
CER_SELF_YEAR
DRUG_D_OTHER
CANCER_OTHER_S_YEAR
BODY_HEIGHT
HDL_C_Ref_1
OCD_SELF
B_SMK_PAG
birth_year
WET_CONTROL9
HYPERTENSION_MOM
DRUG_D_DOSAGE
F_SUPP_2
SUPP_C_TIMES
OVACAN_SELF_YEAR
ALLERGIC_SIS
I_21
ARTICULUS_ACHE_FREQ
DRK_CURR_MONTHS
PLACE_LGST_END
RENAL_FAILURE_BRO_P
D_12
Release_No
INCENSE_B
OCD_SIS
DEMENTIA
CREATININE_Ref_2
LUNG_CANCER_FA
OVA_CANCER_SIS
COFFEE_A
WATER_BOILED
CER_SELF
HERBAL_5_YRS
WET_CONTROL
NUT_KIND_OTHER
HOMO_1_YRS
UTER_MOM
TV
CANCER_OTHER
HERBAL_3_YRS
ANTI_HCV_AB_2
DRK_CURR_C_OTHER
HYPERTENSION_SELF_YEAR
NASOPHARYNGEAL_CANCER_BRO_P
lbody_height
OTHER_HEART_DIS_SIS_KIND
SUPP_B_UNIT_OTHER
GAMMA_GT_Ref_2
DEPRESSION_SELF
ASTHMA_SIS_P
MANIC_DEPRESSION_FA
SUPP_D
G_5_c
I_42
COOK_HOOD_YRS
EMPHYSEMA_OR_BRONCHITIS_SELF_MON
SMK_CURR_FREQ
EPILEPSY_SIS
DYS_SIS_P
I_14
ALLERGIC_MOM_MED
B_SMK_FREQ
DEPRESSION_SELF_MONTH
DYSMENORRHEA_FREQ
I_10
SUPP_E_DOSAGE
SMK_2ND_PLACE2
HERBAL_4_YRS
SCHIZOPHRENIA_SIS_P
CLOTHING_LOWER
ALCOHOLISM_DRUG_ADDICTION
HBA1C
JOB_WEEKLY_HRS
WET_CONTROL1
CARDIOMYOPATHY
ID_BIRTH
PROSTATE_CANCER_S_YEAR
BUN_Ref_2
SEX
IBS_BRO
HBEAG_2
Eeq_Anti_HBcAb_HBeAg
BREAST_CANCER
EPILEPSY_SELF
ANTI_HBC_AB_1
GASTRIC_CANCER_SIS_P
DYS_SELF_YEAR
GOUT_SELF_YEAR
DRUG_B_FREQ
ARRHYTHMIA
DRK_QUIT_A
ORTHOPEDICS_OR_ARTICULUS
SMK_2ND_PLACE4_HRS
DRUG_A_UNIT
HEADACHE_A
MANIC_DEPRESSION_BRO_P
COOK_CURR
SMK_EXPERIENCE
MANIC_DEPRESSION_SELF_YEAR
eduyrs
INDUCE_ABO_TIMES
SUPP_D_UNIT_OTHER
DIABETES_BRO_P
DRK_QUIT_C
HBA1C_Ref_2
VALVE_HEART_DIS_SIS_P
ACHE_OTHER_2_FREQ
JOB_YRS
OTHER_HEART_DIS_MOM_KIND
DRUG_E_OTHER
NERVOUS_SYSTERM
WET_D_LIGHT
FEF25_PRED
WET_CONTROL2
BLOOD_NOTE
inc_family_mid
JOB_LGST_MONTHS
EMPHYSEMA_OR_BRONCHITIS_SIS
GASTRIC_CANCER_MOM
DEPRESSION_SIS
DRUG_A_OTHER
OCD_SIS_P
ALBUMIN_Ref_1
LUNG_CANCER
VERTIGO_SIS_P
HYPERTENSION_BRO_P
COLORECTAL_CANCER_MOM
ALLERGIC_MOM
AGE
DRK_QUIT_C_DOSAGE
CORONARY_ARTERY_DIS_BRO_P
ASTHMA_SELF_MONTH
SPO_ANY_KIND
DRUG_KIND_B
FLOATERS
MS_SIS
HOMO_5_YRS
PARITY_5_MONTHS
AFP_Ref_1
BLIND_R
BODY_WAISTLINE
DRK_CURR_A
JOB_MONTHS
I_23
EMPHYSEMA_OR_BRONCHITIS_SELF
DRUG_C_UNIT
SUPP_C
I_9
UTER_SIS
ACHE
BODY_FAT_RATE
I_38
APOPLEXIA_BRO
APOPLEXIA_SIS_P
GERD_SELF_MONTH
B_DRK_MONTHS
HYPERLIPIDEMIA_BRO_P
OVARIAN_CYST
HYPERTENSION_FA
SPO_ANY_C_MINS
ALCOHOLISM_DRUG_ADDICTION_BRO
OTHER_HEART_DIS_SELF_MONTH
SPO_HABIT_B_FREQ
OTHER_HEART_DIS_SELF_KIND
inc_family_min
G_5_e
ALCOHOLISM_DRUG_ADDICTION_FA
SIT_2_DIASTOLIC_PRESSURE
NATIVE_FA_CHINA_1
SNAKE
HERBAL_1
SENTENCE
DEMENTIA_SELF
CERVICAL_P_SELF_MONTH
HDL_C
NUT_LAST_YRS
ENDO_SELF_MONTH
GOUT_SELF_MONTH
TEA_C_FREQ
I_29
PROSTATE_CANCER_BRO
CONGENITAL_HEART_DIS_SELF
I_3
EMPHYSEMA_OR_BRONCHITIS_SIS_P
PLATELET_Ref_2
ILL_ACT
BODY_WEIGHT
DEPRESSION_BRO_P
BIRTH_AGE_FINAL
TEA_B_FREQ
LIVER_CANCER_SELF
BODY_BUTTOCKS
RBC
LIVER_CANCER_S_YEAR
DEMENTIA_SELF_MONTH
DRUG_KIND_C
ALLERGIC_FA_MED
HEMICRANIA_SELF_MONTH
HEMICRANIA_SIS
CER_SIS
BMI
ASTHMA_SIS
FID
IID
SEX
AGE
birth_year
BODY_HEIGHT
BODY_WEIGHT
lbody_height
BMI
eduyrs
inc_self_mid
inc_family_mid

";
#delimit cr
}


// local list "FID IID SEX AGE birth_year BODY_HEIGHT BODY_WEIGHT lbody_height BMI eduyrs inc_self_mid inc_family_mid"
// global vars "`list'"
//
//
// global vars "${vars} Draw_Date "
//
//
// Draw_Time   時間 X
// HDL_C_Ref    符號 X
// ANTI_HBS_AB_1  英文 O
// BLOOD_NOTE 中文 O
// SUPP_C 中文 O



//=====================================================================================


	/*
	QC steps
	*/ 
	global QC1 = "${filename}A_qc_01_maf"
	global QC2 = "${filename}A_qc_02_missing"
	global QC3 = "${filename}A_qc_03_biallelic"
	global QC4 = "${filename}A_qc_04_sex"
	global QC5 = "${filename}A_qc_05_chrom"
	global QC6 = "${filename}A_qc_06_hwe"
	global QC7 = "${filename}A_qc_07_het"
	global freq = "${filename}A_qc_freq"
	global QC9 = "${filename}A_qc_09_relatedness_done"
	global QC10 = "${filename}A_qc_10_pruned"
	global QC0 = "${filename}A_qc_00_keep"


	// remove SNPs with MAF under threshold
// 	Minor allele frequencies/counts
// 	--maf filters out all variants with minor allele frequency below the provided threshold (default 0.01)
// 	https://www.cog-genomics.org/plink/1.9/filter#maf
	
	cap confirm file "${QC1}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 1 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1
		
		shell "$plink2path" --bfile "${data}" --maf $setmaf --make-bed --out "${QC1}"	
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 1 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC1}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

	}
	
	// remove SNPs and individuals with genotype calls and genotype missingness less than thresholds
// 	Missing genotype rates
// 	--geno filters out all variants with missing call rates exceeding the provided value 
// 	(default 0.1) to be removed, while --mind does the same for samples.
// 	https://www.cog-genomics.org/plink/1.9/filter#missing
	
	cap confirm file "${QC2}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 2 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1
		
		shell "$plink2path" --bfile "${QC1}" --geno $setgeno --mind $setmind --make-bed --out "${QC2}"
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 2 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC2}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'	
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

	}
	
	// remove SNPs that are not biallelic
// 	By default, all variants are loaded; when more than one alternate allele is present,
// 	the reference allele and the most common alternate are tracked (ties broken in favor 
// 	of the lower-numbered allele) and the rest are coded as missing calls. To simply skip all
// 	variants where at least two alternate alleles are present in the dataset, use --biallelic-only.
// 	https://www.cog-genomics.org/plink/1.9/input#vcf_filter
//	
// 	--snps-only excludes all variants with one or more multi-character allele codes. With 'just-acgt', 
// 	variants with single-character allele codes outside of {'A', 'C', 'G', 'T', 'a', 'c', 'g', 't', 
// 	<missing code>} are also excluded.
// 	https://www.cog-genomics.org/plink/1.9/filter#snps_only
	
	cap confirm file "${QC3}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 3 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
// 		shell "$plinkpath" --bfile "${QC2}" --snps-only just-acgt --biallelic-only strict list --make-bed --out "${QC3}"	
		shell "$plink2path" --bfile "${QC2}" --snps-only just-acgt --max-alleles 2 --make-bed --out "${QC3}"	
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 3 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC3}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'	
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

	}
	
	local nextfile = "${QC3}"
	if "$datatype" != "imputation"{
		cap confirm file "${QC4}.bed"
		if (_rc & ${nstart_from}==.)| (${nstart_from}<= 4 & ${nstart_from}!=.) {

			// check if reported sex is the same as imputed sex from genetic data, remove individual if not
// 			Sex imputation
// 			--check-sex normally compares sex assignments in the input dataset with those
// 			imputed from X chromosome inbreeding coefficients, and writes a report to plink.sexcheck.
// 		    https://www.cog-genomics.org/plink/1.9/basic_stats#check_sex
			
			timer clear 1
			timer on 1	
			
			shell "$plinkpath" --bfile "${QC3}" --check-sex --out "${QC4}"
			
			local stop 0
			cap file close log
			file open log using "${QC4}.log", read 
			file read log line
			while r(eof)==0{
				file read log line
				local a =word(`"`line'"', 1)
				if "`a'" == "Error:"{
					local stop 1
					di `"`line'"'
				}
			}
			file close log
			
			if `stop'==1{
				error 1 /*force break*/
			}
			
			qui import delimited "${QC4}.sexcheck", delimiter(whitespace, collapse) case(preserve) clear 
			qui keep if STATUS == "PROBLEM"
			qui keep FID IID
			qui export delimited using "${QC4}.txt", nolab delimiter(tab) replace
			shell "$plink2path" --bfile "${QC3}" --remove "${QC4}.txt" --make-bed --out "${QC4}"
			
			local stop 0
			cap file close log
			file open log using "${QC4}.log", read 
			file read log line
			while r(eof)==0{
				file read log line
				local a =word(`"`line'"', 1)
				if "`a'" == "Error:"{
					local stop 1
					di `"`line'"'
				}
			}
			file close log
			
			if `stop'==1{
				error 1 /*force break*/
			}

			timer off 1
			qui timer list 1
			local time1 = r(t1)/60
			di "qc 4 used `time1'  minutes"
			
		}
		
		
		// keep chromosomes 1-22 only 
// 	Chromosomes
// 	--chr excludes all variants not on the listed chromosome(s). 
// 	Normally, valid choices for humans are 0 (i.e. unknown), 1-22, X, Y, XY 
// 	(pseudo-autosomal region of X; see --split-x/--merge-x), and MT.
// 	https://www.cog-genomics.org/plink/1.9/filter#chr
	
		cap confirm file "${QC5}.bed"
		if (_rc & ${nstart_from}==.)| (${nstart_from}<= 5 & ${nstart_from}!=.) {

			timer clear 1
			timer on 1	
			
			shell "$plink2path" --bfile "${QC4}" --chr 1-22 --make-bed --out "${QC5}"	
			
			timer off 1
			qui timer list 1
			local time1 = r(t1)/60
			di "qc 5 used `time1'  minutes"
		
			local stop 0
			cap file close log
			file open log using "${QC5}.log", read 
			file read log line
			while r(eof)==0{
				file read log line
				local a =word(`"`line'"', 1)
				if "`a'" == "Error:"{
					local stop 1
					di `"`line'"'	
				}
			}
			file close log
			
			if `stop'==1{
				error 1 /*force break*/
			}

		}
		
		local nextfile = "${QC5}"
	}
	
	
	if "`nextfile'"=="${QC3}"{
		di "qc 4 & 5 skipped"
	}
	
	
	// keep only SNPs that does not deviate from hardy-weinberg equilibrium 
// 	Hardy-Weinberg equilibrium tests
// 	--hwe filters out all variants which have Hardy-Weinberg equilibrium exact 
// 	test p-value below the provided threshold.
//  https://www.cog-genomics.org/plink/1.9/filter#hwe
	
	cap confirm file "${QC6}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 6 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
		shell "$plink2path" --bfile "`nextfile'" --hwe 1e-6 --make-bed --out "${QC6}"
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 6 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC6}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'	
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

	}

	// exclude individuals with heterozygosity rates that are too high or too low  	
// 	Inbreeding
// 	--het computes observed and expected autosomal homozygous genotype counts 
// 	for each sample, and reports method-of-moments F coefficient estimates 
// 	(i.e. (<observed hom. count> - <expected count>) / (<total observations> - <expected count>)) to plink.het. 
//  https://www.cog-genomics.org/plink/1.9/basic_stats#ibc
	
	cap confirm file "${QC7}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 7 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
		shell "$plinkpath" --bfile "${QC6}" --missing --het --out "${QC7}"
		
		local stop 0
		cap file close log
		file open log using "${QC7}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}
		
		qui import delimited "${QC7}.het", delimiter(whitespace, collapse) case(preserve) clear 
		qui g het_rate = (NNM-OHOM)/NNM
		qui sum het_rate
		local mean = r(mean)
		local std = r(sd)
		local upper_bound = `mean' + 3*`std'
		local lower_bound = `mean' - 3*`std'
		qui keep if het_rate > `upper_bound' | het_rate < `lower_bound'
		qui export delimited using "${QC7}.txt", nolab delimiter(tab) replace	
		shell "$plink2path" --bfile "${QC6}" --remove "${QC7}.txt" --make-bed --out "${QC7}"
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 7 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC7}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

	}
	
	// kinship based pruning  
// 	--king-cutoff excludes one member of each pair of samples with kinship coefficient greater than the given threshold
// 	https://www.cog-genomics.org/plink/2.0/distance#king_coefs

	cap confirm file "${QC9}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 8 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
		shell "$plink2path" --bfile "${QC7}" --king-cutoff $setking --make-bed --out "${QC9}"	
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 9 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC9}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

	}
			
//===============================================================================================================================		
		
	//----------------------------------------------------------------------------------------------------	
	
foreach s of global sex{
	local ss `s'
	global keepfile = "02_twb1+2_input`ss'_30K_20201116.txt"
	
	
	/*
	obtain principal components: using SNPs not in LD, obtain eigenvectors as the PCs
	*/ 
	
// 	These commands produce a pruned subset of markers that are in approximate linkage equilibrium with each other, 
// 	writing the IDs to plink.prune.in (and the IDs of all excluded variants to plink.prune.out).
// 	--indep-pairwise is the simplest approach, which only considers correlations between unphased-hardcall 
// 	allele counts. It takes three parameters: a required window size in variant count or kilobase 
// 	(if the 'kb' modifier is present) units, an optional variant count to shift the window at the end of each 
// 	step (default 1, and now required to be 1 when a kilobase window is used), and a required r2 threshold. 
// 	At each step, pairs of variants in the current window with squared correlation greater than the threshold are 
// 	noted, and variants are greedily pruned from the window until no such pairs remain.
// 	https://www.cog-genomics.org/plink/2.0/ld#indep

	global name2 = "${filename}B_gwas`ss'_covar+`pcs'pc"
	cap confirm file "${name2}.txt"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 9 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	

		shell "$plink2path" --bfile "${QC9}" --indep-pairwise $setwindow $setstep $setr2 --out "${QC10}"
		
		local stop 0
		cap file close log
		file open log using "${QC10}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'	
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}

		local pcs1 = ${pcs}-1
		global pclist = ""
		if ${pcs} !=0{
			foreach i of numlist 1/`pcs1'{
				global pclist = "$pclist PC`i',"
			}
			global pclist = "$pclist PC${pcs}"
		}
		
// 	Population stratification
// 	--pca extracts top principal components from the variance-standardized relationship matrix 
// 	computed by --make-rel/--make-grm-{bin,list}.
//  The 'approx' modifier causes the standard deterministic computation to be replaced 
//  with the randomized algorithm originally implemented for Galinsky KJ, Bhatia G, Loh PR, 
//  Georgiev S, Mukherjee S, Patterson NJ, Price AL (2016) Fast Principal-Component Analysis 
//  Reveals Convergent Evolution of ADH1B in Europe and East Asia. This can be a good idea 
//  when you have >5000 samples, and is almost required once you have >50000.
// 	https://www.cog-genomics.org/plink/2.0/strat#pca	


		global pc1 = "${filename}B`ss'_pcs_with_ibd_${pcs}"   
		shell "$plink2path" --bfile "${QC9}" --extract "${QC10}.prune.in" --pca $pcs approx --out "$pc1"
		
		local stop 0
		cap file close log
		file open log using "${pc1}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'	
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}
		
		if `stop'==1{
			error 1 /*force break*/
		}
		
		qui import delimited "${pc1}.eigenvec", delimiter(whitespace, collapse) case(preserve) clear 
		tempfile mergefile
		qui save `mergefile'
		
		
		qui import delimited "$keepfile", case(preserve) encoding(UTF-8) clear 
		keep if $condition
		keep $vars
		
		qui merge 1:1 IID using `mergefile', nogen keep(match)
		qui export delimited using "${name2}.txt", nolab delimiter(tab) replace

		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "calculate pc used `time1'  minutes"

	}


//  QC0 
	// keep only individuals with survey data 
// 	ID lists
// 	--keep accepts one or more space/tab-delimited text files with sample IDs, 
// 	and removes all unlisted samples from the current analysis; --remove does the same for all listed samples.
// 	--extract normally accepts one or more text file(s) with variant IDs (usually one per line, 
// 	but it's okay for them to just be separated by spaces), and removes all unlisted variants from the current analysis.
// 	https://www.cog-genomics.org/plink/1.9/filter#indiv
	
	
	cap confirm file "${QC0}.bed"
	if (_rc & ${nstart_from}==.) | (${nstart_from}<= 10 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1
		
		shell "$plink2path" --bfile "${QC9}" --keep "$keepfile" --make-bed --out "$QC0"
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 0 used `time1'  minutes"			

		local stop 0
		cap file close log
		file open log using "${QC0}.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'	
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}
	}
	

	
	/*
	run GWAS
	*/ 
// 	Regression with multiple covariates - Plink 1.9
// 	Given a quantitative phenotype and possibly some covariates (in a --covar file), 
// 	--linear writes a linear regression report to plink.assoc.linear. Similarly, 
// 	--logistic performs logistic regression given a case/control phenotype and some covariates.
// 	https://www.cog-genomics.org/plink/1.9/assoc#linear

// 	Association analysis - Plink 2.0
// 	Linear and logistic/Firth regression with covariates
// 	--glm is PLINK 2.0's primary association analysis command.
// 	https://www.cog-genomics.org/plink/2.0/assoc#glm
	
// 	Phenotype encoding
// 	--input-missing-phenotype <integer>
// 	--no-input-missing-phenotype
// 	Missing case/control or quantitative phenotypes are expected to be encoded as 
// 	'NA'/'nan' (any capitalization) or -9. (Other strings which don't start with a number 
// 	are now interpreted as categorical phenotype/covariate values.) You can change the 
// 	numeric missing phenotype code to another integer with --input-missing-phenotype, 
// 	or just disable -9 with --no-input-missing-phenotype.
//  https://www.cog-genomics.org/plink/2.0/input#input_missing_phenotype
	
// 	Covariates
// 	--covar designates the file to load covariates from. The file format is the same as for --pheno
// 	https://www.cog-genomics.org/plink/2.0/input#covar

	
	foreach p of global phenos{
		global name3 = "${filename}C_gwas`ss'_`p'_${pcs}pc"
		global name4 = "${name3}_wo_covar"
		
		cap confirm file "${name4}.txt"
		if (_rc & ${nstart_from}==.)| (${nstart_from}<= 11 & ${nstart_from}!=.) {

			timer clear 1
			timer on 1	

			
			global covars = "birth_year"
			if "`s'"=="`_a'"{
				global covars = "birth_year, SEX"
			}
			
			if ${pcs}!=0{
				global covars = "${covars}, ${pclist}"
			}	
			
// 			shell "$plink2path" --bfile "${QC0}" --pheno "${name2}.txt" --pheno-name `p' ///
// 					--covar "${name2}.txt" --covar-name $covars --prune --variance-standardize ///
// 					--linear intercept --out "${name3}"

			shell "$plink2path" --bfile "${QC0}" --pheno "${name2}.txt" --pheno-name `p' ///
					--covar "${name2}.txt" --covar-name $covars --variance-standardize ///
					--linear intercept  --out "${name3}"
					
// 			shell "$plinkpath" --bfile "${QC9}" --pheno "${name2}.txt" --pheno-name `p' ///
// 					--covar "${name2}.txt" --covar-name $covars --missing-phenotype -9 ///
// 					--linear intercept --out "${name3}"

			timer off 1
			qui timer list 1
			local time1 = r(t1)/60
			di "gwas `p' used `time1'  minutes"
			
			local stop 0
			cap file close log
			file open log using "${name3}.log", read 
			file read log line
			while r(eof)==0{
				file read log line
				local a =word(`"`line'"', 1)
				if "`a'" == "Error:"{
					local stop 1
					di `"`line'"'	
				}
			}
			file close log
			
			if `stop'==1{
				error 1 /*force break*/
			}
					
			
			// select GWAS output file -- unknown extension other than .log, .png and .txt
			local file: dir . files "${name3}*"
			global gwas_output ""
			foreach f of local file{
				local pos = strrpos("`f'", ".")
				local ext = usubstr("`f'", `pos', .)
				if  !inlist("`ext'", ".log", ".png", ".txt") {
					global gwas_output "`f'"
				}
			}
			
			// keep betas for the SNPs only
			qui import delimited "$gwas_output", delimiter(whitespace, collapse) case(preserve) clear 
			cap qui drop v*
			qui keep if TEST=="ADD"
			qui export delimited using "${name4}.txt", nolab delimiter(tab) replace

		}
		
		
		/*
		manhattan plot

		manhattan CHR BP P, title("`p'") 		
		*/ 
		
		
		/*
		clumping
		*/ 
// 		LD-based result clumping
// 		When there are multiple significant association p-values in the same region, 
// 		LD should be taken into account when interpreting the results. 
// 		The --clump command is designed to help with this.
// 		--clump loads the named PLINK-format association report(s) 
// 		(text files with a header line, a column containing variant IDs, and another column containing p-values) 
// 		and groups results into LD-based clumps, writing a new report to plink.clumped.
// 		https://www.cog-genomics.org/plink/1.9/postproc#clump
		
		foreach sl of global siglevel_list{
			local sig = "`sl'"
			if "`sl'"=="0.000001"{
				local sig = "1e-6"
			}
			if "`sl'"=="0.00000005"{
				local sig = "5e-8"
			}
			
			
			global name7 = "${filename}D_gwas`ss'_clumped_`p'_pc${pcs}_sl`sig'"
			global name8 = "${name7}_index_SNPs"
			global check = "${name7}.clumped"

			cap confirm file "$check"
			if (_rc & ${nstart_from}==.)| (${nstart_from}<= 12 & ${nstart_from}!=.) {

				timer clear 1
				timer on 1	

				shell "$plinkpath" --bfile "${QC0}" --clump "${name4}.txt" --clump-snp-field ID ///
						--clump-p1 `sl' --clump-p2 `sl' --clump-r2 $setclumpr2 --clump-kb $setclumpkb --out "${name7}"
						
				timer off 1
				qui timer list 1
				local time1 = r(t1)/60
				di "clump `ss' `p' `sig' used `time1'  minutes"
				
				local stop 0
				cap file close log
				file open log using "${name7}.log", read 
				file read log line
				while r(eof)==0{
					file read log line
					local a =word(`"`line'"', 1)
					if "`a'" == "Error:"{
						local stop 1
						di `"`line'"'	
					}
				}
				file close log
				
				if `stop'==1{
					error 1 /*force break*/
				}

			}		
								
			capture confirm file "$check"
			if !_rc{
				global name9 = "${filename}E_prs`ss'_`p'_pc${pcs}_sl`sig'"
				capture confirm file "${name9}.profile"
				if (_rc & ${nstart_from}==.)| (${nstart_from}<= 13 & ${nstart_from}!=.) {
		
					/*
					calculate PRS with SNPs with p-values under threshold
					*/
// 					additive effect estimates for a quantitative trait
// 					The --score flag performs this function, writing results to plink.profile
// 					The input file should have one line per scored variant. By default, the variant ID is read from column 1, 
// 					an allele code is read from the following column, and the score associated with the named allele is read 
// 					from the column after the allele column; you can change these positions by passing column numbers to --score.
// 					e.g. --score my.scores 2 4 9
// 					reads variant IDs from column 3, allele codes from column 2, and scores from column 1.
// 					https://www.cog-genomics.org/plink/1.9/score
					
					timer clear 1
					timer on 1	

					qui import delimited "$check", delimiter(whitespace, collapse) case(preserve) clear 
					qui keep SNP
					qui export delimited using "${name8}.txt", nolab delimiter(tab) replace
					shell "$plinkpath" --bfile "${QC0}" --score "${name4}.txt" 3 6 9 header  ///
							--extract "${name8}.txt" --out "${name9}"
// 					shell "$plinkpath" --bfile "${QC0}" --score "${name4}.txt" 2 4 9 header  ///
// 							--extract "${name8}.txt" --out "${name9}"							
					timer off 1
					qui timer list 1
					local time1 = r(t1)/60
					di "calculate prs `ss' `p' `sig' used `time1'  minutes"
					
					local stop 0
					cap file close log
					file open log using "${name9}.log", read 
					file read log line
					while r(eof)==0{
						file read log line
						local a =word(`"`line'"', 1)
						if "`a'" == "Error:"{
							local stop 1
							di `"`line'"'
						}
					}
					file close log
					
					if `stop'==1{
						error 1 /*force break*/
					}

				}		
				
				/*
				recode file: calculate number of reference alleles for index SNPs for individuals with survey data
				*/
// 				--recode creates a new text fileset, after applying sample/variant filters and other operations.
// 				By default, A1 alleles are counted; this can be customized with --recode-allele. 
// 				--recode-allele's input file should have variant IDs in the first column and allele IDs in the second.
// 				https://www.cog-genomics.org/plink/1.9/data#recode
				
				global name10 = "${filename}F_gwas`ss'_`p'_pc${pcs}_sl`sig'_recoded"						
				capture confirm file "${name10}.raw"
				if (_rc & ${nstart_from}==.)| (${nstart_from}<= 14 & ${nstart_from}!=.) {

					timer clear 1
					timer on 1	

					qui import delimited "${name4}.txt", case(preserve) clear 
					
					cap rename ID SNP
					qui keep SNP A1
					qui export delimited using "${name4}_SNP+A_only.txt", nolab delimiter(tab) replace
					
					shell "$plinkpath" --bfile "${QC0}" --extract "${name8}.txt" ///
							--recode A tab --recode-allele "${name4}_SNP+A_only.txt" ///
							--output-missing-genotype N --out "${name10}"
							
					timer off 1
					qui timer list 1
					local time1 = r(t1)/60
					di "recode data `ss' `p' `sig' used `time1'  minutes"
					
					local stop 0
					cap file close log
					file open log using "${name10}.log", read 
					file read log line
					while r(eof)==0{
						file read log line
						local a =word(`"`line'"', 1)
						if "`a'" == "Error:"{
							local stop 1
							di `"`line'"'	
						}
					}
					file close log
					
					if `stop'==1{
						error 1 /*force break*/
					}

				}

			}/*file exist*/
			
			if _rc{
				di "	no significant SNP for `p' GWAS p<`sig'"
			}
		}/*sl*/		
		di "--------------------------------"
	}/*pheno*/
	di "========================================="
}/*sex*/



	
	
	