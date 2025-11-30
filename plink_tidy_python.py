# trial6_20201027 - twb2 + keep + separate sex from qc

# pip install delegator.py
# pip install qqman
import delegator
import os
import time
import timeit
import datetime
import pandas as pd
import numpy as np
from qqman import qqman

cd = "D:/User_Data/Desktop/gene/trial6_20201027"

os.chdir(cd)

plink_path = "D:/User_Data/Desktop/gene/plink/plink.exe"
plink2_path = "D:/User_Data/Desktop/gene/plink2/plink2.exe"


# keep only individuals with survey data
# arguments: input data; file with individual and family IDs in the first two columns;
# output data name
def keep(input, keep, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    keep = " --keep " + keep + ".txt"
    command = plink + bfile + keep + " --make-bed " + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# caculate minor allele frequencies
# arguments: data to calculate MAF; name of MAF output file
def freq(arg1, arg2):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + arg1
    output = " --out " + arg2
    command = plink + bfile + " --freq " + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# remove SNPs with MAF under threshold
# arguments: input data name; MAF threshold; output file name
def qc_maf(input, threshold, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    maf = " --maf " + str(threshold)
    command = plink + bfile + maf + " --make-bed" + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# remove SNPs and individuals with call rate less than thresholds
# arguments: input data name; call rate threshold for SNPs; call rate threshold for individuals;
# output data name
def qc_missing(input, geno_threshold, mind_threshold, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    geno = " --geno " + str(geno_threshold)
    mind = " --mind " + str(mind_threshold)
    command = plink + bfile + geno + mind + " --make-bed" + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# remove SNPs that are not biallelic
# arguments: input file name; output file name
def qc_snps_biallelic(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    snps = " --snps-only just-acgt "
    biallelic = " --biallelic-only strict list "
    command = plink + bfile + snps + biallelic + " --make-bed" + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# update sex information from text file and produce new bim fam bed files
# arguments: input file name; name of file with sex data;
# n = column where sex is in minus 2,  in plink files = 1 (=sex in 3rd column);
# output file name
# not used (fam file replaced with stata)
def update_sex(file, sex_file, nplus2thcolumn, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    sfile = sex_file + ".txt"
    df = pd.read_csv(sfile, sep='\t', engine='python')
    df2 = df.drop_duplicates(subset=['FID', 'SEX'])
    df2.to_csv("temp.txt", header=True, index=False, sep='\t', mode='w')

    plink = plink_path
    bfile = " --bfile " + file
    output = " --out " + output
    sexfile = " --update-sex temp.txt " + str(nplus2thcolumn)
    command = plink + bfile + sexfile + " --make-bed" + output
    print(command)
    c = delegator.run(command)
    print(c.out)

    os.remove("temp.txt")

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# python version of changing values in the sex column of the fam file
# instead of using the update-sex function above
# arguments: name of input fam file; file with sex data; output fam file name
# not used, may exist bugs
def new_fam(fam, sexfile, output):
    fam = fam + ".fam"
    sexfile = sexfile + ".txt"
    df = pd.read_csv(fam, sep=" ", engine='python', header=None)
    df2 = pd.read_csv(sexfile, sep="\t", engine='python')
    result = pd.merge(df, df2, left_on=0, right_on='FID')
    result['SEX'] = result['SEX'].fillna(0)
    df[4] = result['SEX']
    df[4] = df[4].fillna(0)
    df[4] = df[4].astype(int)
    output = output + ".fam"
    df.to_csv(output, header=False, index=False, sep='\t', mode='w')


# check if reported sex is the same as imputed sex from genetic data
# arguments: file name before sex check; file name after sex check
def qc_sex(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    # run plink command
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + output

    # report sexcheck report
    # command = plink +  bfile + " --check-sex" + out

    # change sex to imputed values and report
    command = plink + bfile + " --impute-sex --make-bed " + out
    sex_file = output + '.sexcheck'
    print(command)
    c = delegator.run(command)
    print(c.out)

    # read file and keep IDs of the ones with problems
    df = pd.read_csv(sex_file, delim_whitespace=True)
    df = df.loc[df['STATUS'] != 'OK']

    txt_name = output + ".txt"
    df.to_csv(txt_name, header=True, index=False, sep='\t', mode='w')

    # ask plink to remove problematic individuals
    command = plink + bfile + " --remove " + txt_name + " --make-bed " + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# keep chromosomes 1-22 only
# arguments: file before removing; file name after excluding chromosomes other than 1-22
def qc_chrom(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    command = plink + bfile + " --chr 1-22 --make-bed " + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# keep only SNPs that does not deviate from hardy-weinberg equilibrium
# arguments: input file name; output file name
def qc_hwe(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    command = plink + bfile + " --hwe 1e-6 --make-bed " + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# heterozygosity
# arguments: input file name; output file name
def qc_het(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    # obtain .het file
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + output
    command = plink + bfile + " --het" + out
    command = plink + bfile + " --missing --het" + out
    het_file = output + '.het'
    missing_file = output + '.imiss'

    print(command)
    c = delegator.run(command)
    print(c.out)

    # calculate heterozygosity rates for each individual, and
    # mark those deviating +-3 standard deviation from the sample heterozygosity rate mean

    df = pd.read_csv(het_file, delim_whitespace=True)
    df["het_rate"] = (df['N(NM)'] - df['O(HOM)']) / df['N(NM)']
    het_mean = df["het_rate"].mean()
    het_std = df["het_rate"].std()
    upper_bound = het_mean + 3 * het_std
    lower_bound = het_mean - 3 * het_std
    df = df[(df['het_rate'] > upper_bound) | (df['het_rate'] < lower_bound)]

    txt_name = output + ".txt"
    df.to_csv(txt_name, header=True, index=False, sep='\t', mode='w')

    # tell plink to remove these individuals
    command = plink + bfile + " --remove " + txt_name + " --make-bed " + out
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# pruning plus calculating identity-by-descent
# arguments: input file name; pruning window (enter "default" sets to 50);
# pruning step (enter "default" sets to 5);
# pruning R2 threshold (enter "default" sets to 0.2);
# IBD threshold (enter "default" sets to 0.1875);
# output file name

# about IBD threshold:
# 1: duplicates or monozygotic twins
# 0.5: first-degree relatives
# 0.25: second-degree relatives
# >0.1875: halfway between the expected IBD for third-and-second-degree relative
# 0.125: third-degree relatives
def qc_relatedness_prune_ibd(input, window, step, threshold, pihat, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + output

    if window == 'default':
        window = 50
    if step == 'default':
        step = 5
    if threshold == 'default':
        threshold = 0.2
    if pihat == 'default':
        pihat = 0.1875
    prune = " --indep-pairwise " + str(window) + " " + str(step) + " " + str(threshold)

    command = plink + bfile + prune + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    extract = " --extract " + output + ".prune.in"
    command = plink + bfile + extract + " --genome --min " + str(pihat) + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# identical to the previous function except for including pruning only, without steps for IBD
# arguments: input file name; pruning window; pruning step; pruning R2 threshold; output file name
def qc_relatedness_prune(input, window, step, threshold, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + output

    if window == 'default':
        window = 50
    if step == 'default':
        step = 5
    if threshold == 'default':
        threshold = 0.2
    prune = " --indep-pairwise " + str(window) + " " + str(step) + " " + str(threshold)

    command = plink + bfile + prune + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# do clumping, sorted by minor allele frequencies, those with largest MAF comes first
# arguments: input file name; file with MAF information;
# clumping threshold for index and other SNPs
# (set to 1 here if enter "default", meaning including all SNPs, sort by MAF so that the ones with
# higher MAF are more prone to be selected as index SNPs);
# clumping R2 threshold (enter "default" sets to 0.5);
# clumping distance threshold (enter "default" sets to 250);
# output file name
def qc_relatedness_clump(input, result, p1, p2, r2, kb, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + output

    # edit the file containing information on MAFs, adding a column named P that is able to sort the
    # file in the reverse order of MAF, i.e., the ones with higher MAF will be treated as
    # the more important in the following clumping steps (plink default clumps SNPs with
    # the smallest values first)

    file = result + ".frq"
    df = pd.read_csv(file, delim_whitespace=True)
    df['P'] = 1 - df['MAF']
    df.to_csv(file, index=False, sep='\t', mode='w')

    # tell plink to do clumping

    result = " --clump " + result + ".frq "

    if p1 == 'default':
        p1 = 1
    if p2 == 'default':
        p2 = 1
    if r2 == 'default':
        r2 = 0.5
    if kb == 'default':
        kb = 250

    p1 = " --clump-p1 " + str(p1)
    p2 = " --clump-p2 " + str(p2)
    r2 = " --clump-r2 " + str(r2)
    kb = " --clump-kb " + str(kb)

    command = plink + bfile + result + p1 + p2 + r2 + kb + " --clump-field P " + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# obtain a file that consists of all SNPs in LD with some other SNPs
# arguments: input .clumped file name; output text file name
def clumped_snps(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    clumpfile = input + ".clumped"
    df = pd.read_csv(clumpfile, delim_whitespace=True)
    df.dropna(subset=['SNP'], inplace=True)  # remove empty rows
    df = df[df.SP2 != 'NONE']  # keep rows that includes clumps
    df = df[['SNP', 'SP2']]
    s = df['SNP']

    # split the clumps and append all SNPs into one column
    df2 = df['SP2'].str.split(',', expand=True).rename(columns=lambda x: "SNP" + str(x + 1))
    for i in range(len(df2.columns)):
        now = df2[df2.columns[i]].str.replace(r"\(.*\)*", "")
        now.dropna(inplace=True)
        s = s.append(now, ignore_index=True)

    filename = output + ".txt"
    s.to_csv(filename, header=False, index=False, sep='\t', mode='w')

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# using SNPs that are in LD, calculate identity-by-descent of all sample pairs
# arguments: input file name; file with SNPs in LD, which is the output of the function above;
# IBD threshold (see description of function qc_relatedness_prune_ibd for more details
# on the threshold; enter "default" sets to 0.1875);
# number of splits of the process (solution for memory error, allows 0); output file name
def qc_relatedness_ibd(input, clumpedsnps, pihat, splits, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + output

    if pihat == 'default':
        pihat = 0.1875

    extract = " --extract " + clumpedsnps + ".txt"

    if splits != 0:  # split process so that no memory error would occur
        for part in range(splits):
            num = str(part + 1)
            command = plink + bfile + extract + " --genome --min " + str(pihat) + \
                      " --parallel " + num + " " + str(splits) + out
            print(command)
            c = delegator.run(command)
            print(c.out)
    if splits == 0:
        command = plink + bfile + extract + " --genome --min " + str(pihat) + out
        print(command)
        c = delegator.run(command)
        print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# calculates call rates for all individuals and combine with individual pair ibds,
# save the individuals with the lower call rate, and remove them with plink
# arguments: input file name; file with ibd information; file name with missingness information;
# number of splits from the previous function; output file name
def qc_relatedness_call(input, ibdfile, imissfile, splits, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    out = " --out " + imissfile

    command = plink + bfile + " --missing " + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    if splits == 0:
        genome = ibdfile + ".genome"
        genome = pd.read_csv(genome, delim_whitespace=True)
    else:
        for i in range(splits):  # append split ibd files
            j = str(i + 1)
            file = ibdfile + ".genome." + j
            if i == 0:
                df = pd.read_csv(file, delim_whitespace=True)
                genome = df
            else:
                df = pd.read_csv(file, delim_whitespace=True, header=None)
                df.columns = genome.columns
                genome = pd.concat([genome, df], ignore_index=True)

    miss = imissfile + ".imiss"
    miss = pd.read_csv(miss, delim_whitespace=True)

    # merge ibd file with missingness file
    result = pd.merge(genome[["FID1", "IID1", "FID2", "IID2"]],
                      miss[["F_MISS", "FID"]],
                      how='left',
                      left_on='FID1',
                      right_on='FID')
    result = result.drop(columns=['FID'])
    result = result.rename(columns={'F_MISS': "call1"})
    result = pd.merge(result,
                      miss[["F_MISS", "FID"]],
                      how='left',
                      left_on='FID2',
                      right_on='FID')
    result = result.drop(columns=['FID'])
    result = result.rename(columns={'F_MISS': "call2"})

    # save IDs for individual with the lower call rate in the pair
    result['FID'] = np.where(result['call1'] < result['call2'], result['FID1'], result['FID2'])

    s = pd.DataFrame()
    s['FID'] = result['FID']
    s['IID'] = s['FID']

    txt = output + "_remove.txt"
    s.to_csv(txt, header=False, index=False, sep='\t', mode='w')

    out = " --out " + output
    command = plink + bfile + " --remove " + txt + " --make-bed " + out
    print(command)
    c = delegator.run(command)
    print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# produce file with SNPs that are not in clumps of other SNPs (SNPs that are not in LD)
# arguments: clumping output file; name of text file with SNPs not in LD
def produce_indep_snps(clumpfile, output):
    clumpfile = clumpfile + ".clumped"
    output = output + ".txt"
    df = pd.read_csv(clumpfile, delim_whitespace=True)
    df.dropna(subset=['SNP'], inplace=True)  # remove empty rows
    df = df[(df['SP2'] == 'NONE')]
    df = df["SNP"]
    df.to_csv(output, header=False, index=False, sep='\t', mode='w')


# using SNPs not in LD, obtain eigenvectors as the PCs used as covars in GWAS
# arguments: input file name, file with SNPs not in LD (i.e. index SNPs with no clumps);
#     number of PCs to be calculated; output file name
def pca(input, extract, num, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink2 = plink2_path
    bfile = " --bfile " + input
    output = " --out " + output
    # clumpfile = extract + ".clumped"
    infile = extract + ".txt"

    extract = " --extract " + infile

    # command = plink +  bfile + extract + " --pca " + str(num) + " tabs header --memory 24000" + output
    command = plink2 + bfile + extract + " --pca " + str(num) + " approx " + output

    print(command)
    c = delegator.run(command)
    print(c.out)

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# update the covariate file by adding principle components into the file
# arguments: covar file from stata; PC file from the previous function; name of output file
def combine_covar_pcs(covarfile, pcfile, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    covarfile = covarfile + ".txt"
    covarfile = pd.read_csv(covarfile, sep="\t", engine='python')
    pcfile = pcfile + ".eigenvec"
    pcfile = pd.read_csv(pcfile, delim_whitespace=True)
    pcfile = pcfile.rename(columns={'#FID': "FID"})

    # merge the two files together
    result = pd.merge(covarfile,
                      pcfile,
                      how='left',
                      on='FID')
    result = result.drop(columns=['IID_y'])
    result = result.rename(columns={'IID_x': "IID"})
    output = output + ".txt"

    result.to_csv(output, header=True, index=False, sep='\t', mode='w')

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# run gwas
# arguments: input data; phenotype data; phenotypes; covariate data; covariates;
# model (assoc, linear, logistic); output data name
def gwas(input, phenofile, pheno, covarfile, covar, model, output):
    # assoc does not adjust for covars
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output

    phenofile = phenofile + ".txt"
    phenofile = " --pheno " + phenofile
    pheno = " --pheno-name " + pheno
    covarfile = covarfile + ".txt"
    covarfile = " --covar " + covarfile
    covar = " --covar-name " + covar
    model = " --" + model + " intercept "

    command = plink + bfile + phenofile + pheno + covarfile + covar + \
              " --missing-phenotype -9 " + model + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# remove covar results from the massive output file
# arguments: input gwas results including coeffs of covars; output name excluding covar results
def gwas_clean_result_file(input, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    gwasresult = input + ".assoc.linear"
    df = pd.read_csv(gwasresult, delim_whitespace=True)
    df = df[(df['TEST'] == 'ADD')]

    out = output + ".txt"
    df.to_csv(out, index=False, sep='\t', mode='w')

    df = df.drop(columns=['CHR', 'BP', 'A1', 'TEST', 'NMISS', 'BETA', 'STAT'])
    out = output + "_pvalues_only.txt"
    df.to_csv(out, index=False, sep='\t', mode='w')

    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# clumping, sorted by p-value
# arguments: input file; file with p-values;
# clumping p-value threshold for index SNPs (enter "default" sets to 0.0001);
# clumping p-value threshold for other SNPs (enter "default" sets to 0.01);
# clumping R2 threshold (enter "default" sets to 0.5);
# clumping distance threshold (enter "default" sets to 250);
# output file name
def clump(input, gwasresult, p1, p2, r2, kb, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    result = " --clump " + gwasresult + ".txt"

    if p1 == 'default':
        p1 = 0.0001
    if p2 == 'default':
        p2 = 0.01
    if r2 == 'default':
        r2 = 0.5
    if kb == 'default':
        kb = 250

    p1 = " --clump-p1 " + str(p1)
    p2 = " --clump-p2 " + str(p2)
    r2 = " --clump-r2 " + str(r2)
    kb = " --clump-kb " + str(kb)

    command = plink + bfile + result + p1 + p2 + r2 + kb + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# generate a file with index snps only
# arguments: clumping output file; output text file name
def produce_index_snps(clumpfile, output):
    clumpfile = clumpfile + ".clumped"
    output = output + ".txt"
    df = pd.read_csv(clumpfile, delim_whitespace=True)
    df.dropna(subset=['SNP'], inplace=True)  # remove empty rows
    df = df["SNP"]
    df.to_csv(output, header=False, index=False, sep='\t', mode='w')


# calculate PRS
# arguments: input data; file with weights (gwas output betas);
# file with p-value thresholds (enter "" to skip);
# file that include index SNPs only;
# output file name
def calculate_score(input, gwasresult, thresholdfile, clumpfile, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    gwas = gwasresult + ".txt"
    # variant IDs from column 2, allele codes from column 4, and scores from column 9
    score = " --score " + gwas + " 2 4 9 header "

    srange = thresholdfile + ".txt "
    pdata = gwasresult + "_pvalues_only.txt "
    threshold = " --q-score-range " + srange + pdata

    if thresholdfile == "":
        threshold = ""

    extract = " --extract " + clumpfile + ".txt "

    command = plink + bfile + score + threshold + extract + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


# recode data so that we have number of alleles of every significant SNP after clumping for each
# individual
def output_recode(input, clumpfile, recodegwas, output):
    start = datetime.datetime.now()
    print("starting at ", datetime.datetime.now())
    print("")

    # contain SNPs after clumping only
    extract = " --extract " + clumpfile + ".txt "

    recode = recodegwas + ".txt"
    df = pd.read_csv(recode, sep='\t')
    df = df.drop(columns=['BP', 'TEST', 'NMISS', 'STAT', 'CHR', 'BETA', 'P'])

    name = recodegwas + "_SNP+A_only.txt"
    df.to_csv(name, header=False, index=False, sep='\t', mode='w')

    # recode data
    plink = plink_path
    bfile = " --bfile " + input
    output = " --out " + output
    recode = " --recode A tab --recode-allele " + name

    command = plink + bfile + extract + recode + " --output-missing-genotype N " + output
    print(command)
    c = delegator.run(command)
    print(c.out)
    print('ended at ', datetime.datetime.now())
    print("runtime = ", datetime.datetime.now() - start)


data = "E:/Data/Gene/TWBR10810-06_Genotype(TWB2.0)/TWBR10810-06_TWB2"

list = ['_female', '_male', '']
for i in range(len(list)):
    keepfile = "02_plink_txt_input" + list[i] + "_below55_20201027"
    QC0 = 'A' + list[i] + '_qc_00_keep'
    QC1 = "A" + list[i] + "_qc_01_maf"
    QC2 = "A" + list[i] + "_qc_02_missing"
    QC3 = "A" + list[i] + "_qc_03_biallelic"
    QC4 = "A" + list[i] + "_qc_04_sex"
    QC5 = "A" + list[i] + "_qc_05_chrom"
    QC6 = "A" + list[i] + "_qc_06_hwe"
    QC7 = 'A' + list[i] + '_qc_07_het'
    frq = 'A' + list[i] + '_qc_freq'
    QC81 = "A" + list[i] + "_qc_08_clump"
    QC82 = "A" + list[i] + "_qc_08_clump_indep_snps"
    QC83 = "A" + list[i] + "_qc_08_clumped_snps"

    keep(data, keepfile, QC0)
    qc_maf(QC0, 0.1, QC1)
    qc_missing(QC1, 0.02, 0.02, QC2)
    qc_snps_biallelic(QC2, QC3)
    qc_sex(QC3, QC4)
    qc_chrom(QC4, QC5)
    qc_hwe(QC5, QC6)
    qc_het(QC6, QC7)
    freq(QC7, frq)
    qc_relatedness_clump(QC7, frq, "default", "default", "default", "default", \
                         QC81)
    produce_indep_snps(QC81, QC82)
    clumped_snps(QC81, QC83)
    # ----------------------------------------------------------------
    # qc_relatedness_ibd("A_qc_07_het", "A_qc_08_clumped_snps", "default", 10, "A_qc_09_ibd")
    # qc_relatedness_call("A_qc_07_het", "A_qc_09_ibd", "A_qc_10_imiss", 10, "A_qc_11_done")
    # pca("A_qc_11_done", "A_qc_08_clumped_indep_snps", 10, "B_pcs")
    # ----------------------------------------------------------------

    pcs = 3
    pc1 = "B" + list[i] + "_pcs_without_ibd_" + str(pcs)

    pca(QC7, QC82, pcs, pc1)

    name2 = "B_gwas" + list[i] + "_covar+" + str(pcs) + "pc"

    combine_covar_pcs(keepfile, pc1, name2)
    # combine_covar_pcs(gwas0, \
    # "B_pcs", name2)

    list2 = ['eduyrs', 'lbody_height', 'BODY_HEIGHT', 'BMI']

    for j in range(len(list2)):

        # covars = "birth_year, PC1, PC2, PC3, PC4, PC5, PC6, PC7, PC8, PC9, PC10"
        covars = "birth_year, PC1, PC2, PC3"

        if i == 2:
            # covars = "birth_year, SEX, PC1, PC2, PC3, PC4, PC5, PC6, PC7, PC8, PC9, PC10"
            covars = "birth_year, SEX, PC1, PC2, PC3"

        name3 = "C_gwas_out" + list[i] + "_pheno_" + list2[j] + "_" + str(pcs) + "pc"

        gwas(QC7, name2, list2[j], name2, covars, "linear", name3)

        name4 = name3 + "_wo_covar"
        gwas_clean_result_file(name3, name4)

        name5 = name4 + ".txt"
        name6 = name4 + ".png"
        qqman.manhattan(name5, out=name6)

        list3 = [0.00000005, 0.000001, 0.001, 0.01, 0.05, 0.1, 0.5]

        for k in range(len(list3)):
            name7 = "C_gwas" + list[i] + "_clumped_pheno_" + list2[j] + "_pc" + str(pcs) + \
                    "_sl" + str(list3[k])

            clump(QC7, name4, list3[k], list3[k], "default", "default", name7)
            name8 = name7 + "_index_SNPs"

            check = name7 + ".clumped"

            if os.path.isfile(check):
                produce_index_snps(name7, name8)
                name9 = "D_prs" + list[i] + "_calculated_pheno_" + list2[j] + \
                        "_pc10_sl" + str(list3[k])

                calculate_score(QC7, name4, "", name8, name9)

                if (k == 1 or k == 0) and i == 2:
                    name10 = "E_gwas" + list[i] + "_outfile_pheno_" + list2[j] + "_pc" + str(pcs) + \
                             "_sl" + str(list3[k]) + "_recoded"

                    output_recode(QC7, name8, name4, name10)
                else:
                    continue
            else:
                pass
