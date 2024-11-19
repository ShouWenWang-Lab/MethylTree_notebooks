# MethylTree Notebooks

This project contains 4 Jupyter notebooks:

1. **`mouse_LK_only_quality_checking.ipynb`**  
   This notebook is used for quality control after Bismark preprocessing. It evaluates data quality by analyzing the DNA methylation profile near TSS regions and the observed number of CpG sites.

2. **`mouse_LK_downstream_analysis.ipynb`**  
   This is the core notebook for MethylTree analysis, which includes the following steps:
   
   - Selection of genomic regions and generation of annotation files
   - Creation of AnnData objects for single-cell methylation data
   - Generation, correction, and cell-type signal removal of cell-cell similarity matrices

   For datasets with multi-omics information (such as LK and humanCD34), the notebook provides an optional section:  
   **Optional: add RNA and LARRY information in `df_sample`**.  
   In the DNA methylation data, samples are named based on the positions of the 96-well plate, while RNA and LARRY data use unique barcodes for each well. Using the `methyltree.metadata.mapping_from_plate_barcode_to_Lime_barcode` function, the well positions of the 96-well plate can be mapped to their corresponding barcodes. This allows RNA and LARRY data to be matched and integrated with DNA methylation data (based on the same well positions).

3. **`MethScan_notebook.ipynb`**  
   This notebook uses the `MethScan` environment to generate files with MethScan. It needs to be used alternately with the quality control notebook and the downstream analysis notebook. The usage order is as follows: `quality_control`, `methscan_section1`, `quality_control`, `downstream_analysis`, `methscan_section2`, `downstream_analysis`.
   
4. **`MethylTree_all_data.ipynb`**  
   This notebook is used to generate the MethylTree lineage reconstruction heatmaps for all datasets mentioned in the paper. The required `config.yaml` file, metadata information, and AnnData for single-cell DNA methylation are stored in the `metadata/{dataset}` folder.

---

## Replicating the Analysis for Other Datasets

To replicate the analysis for other datasets (such as humanCD34, 293T, H9), follow these steps:

1. **Download Processed Data**  
   For the LK, 293T, H9 dataset, you can download the processed data from the [GEO database](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE262580). For the humanCD34 dataset, you can download the processed data from the [figshare](https://figshare.com/articles/dataset/High-resolution_noninvasive_single-cell_lineage_tracing_in_mice_and_humans_based_on_DNA_methylation_epimutations/27265212?file=49940532). The downloaded data should be placed in the following path:  
   `metadata/{dataset}_all/downstream_R/all_data/met/cpg_level`

2. **Access Configuration Files**  
   The configuration files for the respective datasets can be found in the following directory:  
   `metadata/{dataset}/`

3. **Mapping Efficiency Calculation Files**  
   Files required for calculating mapping efficiency are located in:  
   `bismark/`

