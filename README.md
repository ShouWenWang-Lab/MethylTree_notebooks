# README

## Using MethylTree to Analyze EPI-Clone Datasets (_Last updated: September 29, 2025_)

In the `Using_MethylTree_to_analyze_EPI-Clone_datasets` folder, we applied **MethylTree** to analyze the transplanted mouse dataset `LARRY_mouse1` from the **EPI-Clone** study.  

The analysis included:
- Assessing clone size distribution in `LARRY_mouse1`.  
- Evaluating clonal inference using **all CpGs (453 sites)**, both with and without cell-type signal removal.  
- Comparing performance after applying the **EPI-Clone cutoff (minimum clone size = 9)**.  
- Testing MethylTree with **static CpGs (110 sites)** and **dynamic CpGs (343 sites)** separately (without applying the clone-size cutoff).  

**Summary of findings:**
- Removing cell-type signal improved clonal inference accuracy.  
- Static CpGs provided accuracy comparable to the all-CpG analysis with cell-type signal removal.  
- Dynamic CpGs performed poorly, with very low accuracy.
- Across all datasets, the transplantation condition yielded the most reliable clonal reconstruction, while aging datasets were less accurate, particularly in younger individuals (mouse and human).  

**Conclusion:**  
MethylTree can be effectively applied to the EPI-Clone datasets and demonstrates robustness across different CpG selections and experimental conditions.

**Reference:**
Fu R, Chen M, WangS‐W. DNA methylation meets lineage tracing:history, recent progress, and future directions.Quantitative Biology. 2026;e70017. https://doi.org/10.1002/qub2.70017

---

## Project Overview

This project contains 3 Jupyter notebooks and 3 folders:

1. **`mouse_LK_only_quality_checking.ipynb`**  
   This notebook is used for quality control after Bismark preprocessing. It evaluates data quality by analyzing the DNA methylation profile near TSS regions and the observed number of CpG sites.

2. **`mouse_LK_downstream_analysis.ipynb`**  
   This is the core notebook for MethylTree analysis, which includes the following steps:

   - Creation of AnnData objects for single-cell methylation data
   - Generation, correction, and cell-type signal removal of cell-cell similarity matrices
   - Selection of genomic regions and generation of annotation files (This require you to install R and related packages `Rscripts`)
     
   For datasets with multi-omics information (such as LK and humanCD34), the notebook provides an optional section:  
   **Optional: add RNA and LARRY information in df_sample**.  
   In the DNA methylation data, samples are named based on the positions of the 96-well plate, while RNA and LARRY data use unique barcodes for each well. Using the `methyltree.metadata.mapping_from_plate_barcode_to_Lime_barcode` function, the well positions of the 96-well plate can be mapped to their corresponding barcodes. This allows RNA and LARRY data to be matched and integrated with DNA methylation data (based on the same well positions).

3. **`MethylTree_all_data.ipynb`**  
   This notebook is used to generate the MethylTree lineage reconstruction heatmaps for all datasets mentioned in the paper. The required `config.yaml` file, metadata information, and AnnData for single-cell DNA methylation are stored in the `metadata/{dataset}` folder.

The required file can be downloaded from [figshare](https://figshare.com/articles/dataset/High-resolution_noninvasive_single-cell_lineage_tracing_in_mice_and_humans_based_on_DNA_methylation_EPImutations/27265212?file=49943949).

---

## Replicating the Analysis for Other Datasets

To replicate the analysis for other datasets (such as humanCD34, LK, 293T, H9), follow these steps:

1. **Download Processed Data**  
   You can download the processed data from the [GEO database](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE262580). The downloaded data should be placed in the following path:`metadata/{dataset}_all/downstream_R/all_data/met/cpg_level`

2. **Access Configuration Files**  
   The configuration files for the respective datasets can be found in the following directory:`metadata/{dataset}/`

3. **Placing Data for humanCD34**  
   For the humanCD34 dataset, place the related data in the following folder:`humanCD34/`

4. **Mapping Efficiency Calculation Files**  
   Files required for calculating mapping efficiency are located in:`bismark/`

   
