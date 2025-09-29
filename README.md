# README

## Using MethylTree to Analyze EPI-Clone Datasets (_September 29, 2025_)

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

## Using MethylTree to Analyze MethylTree Datasets (_October, 2024_)

This section contains **3 Jupyter notebooks** and **3 folders** for analyzing MethylTree datasets.  

### Jupyter Notebooks

1. **`mouse_LK_only_quality_checking.ipynb`**  
   Used for **quality control** after Bismark preprocessing. It evaluates data quality by analyzing DNA methylation profiles near TSS regions and the observed number of CpG sites.

2. **`mouse_LK_downstream_analysis.ipynb`**  
   Core notebook for **MethylTree analysis**, including:
   - Creation of **AnnData** objects for single-cell methylation data.
   - Generation, correction, and cell-type signal removal of cell-cell similarity matrices.
   - Selection of genomic regions and generation of annotation files (require R and related R packages in `Rscripts` folder).
     
   For datasets with multi-omics information (e.g., LK and humanCD34), the notebook provides an **optional section**:  
   - add **RNA and LARRY information** into `df_sample` by mapping plate barcodes to well positions.  
   In the DNA methylation data, samples are named based on the positions of the 96-well plate, while RNA and LARRY data use unique barcodes for each well. Using the `methyltree.metadata.mapping_from_plate_barcode_to_Lime_barcode` function, the well positions of the 96-well plate can be mapped to their corresponding barcodes.

3. **`MethylTree_all_data.ipynb`**  
   Generate **lineage reconstruction heatmaps** for all datasets mentioned in the paper.
   - Requires `config.yaml`, metadata, and AnnData for single-cell DNA methylation.
   - Data and configuration files are organized in the `metadata/{dataset}` folder.

The required file can be downloaded from [figshare](https://figshare.com/articles/dataset/High-resolution_noninvasive_single-cell_lineage_tracing_in_mice_and_humans_based_on_DNA_methylation_EPImutations/27265212?file=49943949).

### Replicating the Analysis for Other Datasets in MethylTree Paper

To replicate the analysis (e.g., humanCD34, LK, 293T, H9), follow these steps:

1. **Download Processed Data**  
   Download the processed data from [GEO database](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE262580).
   Place downloaded files in:`metadata/{dataset}_all/downstream_R/all_data/met/cpg_level`

3. **Access Configuration Files**  
   Configuration files are stored in: `metadata/{dataset}/`

4. **Placing Data for humanCD34**  
   Related data should be organized under: `humanCD34/`

5. **Mapping Efficiency Calculation Files**  
   Files for mapping efficiency are located in: `bismark/`

### Summary

- The provided notebooks cover **quality control, downstream analysis, and full-data heatmap generation**.  
- The pipeline supports **multi-omics integration** (RNA + LARRY).  
- Data and configuration files are organized in a clear folder structure, with processed data available from **Figshare** and **GEO**.  

### Reference

Chen, M., Fu, R., Chen, Y. et al. High-resolution, noninvasive single-cell lineage tracing in mice and humans based on DNA methylation epimutations. Nat Methods 22, 488–498 (2025). https://doi.org/10.1038/s41592-024-02567-1
