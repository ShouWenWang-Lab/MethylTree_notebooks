suppressMessages(library(GenomicRanges))
suppressMessages(library(rtracklayer))
#suppressMessages(library(BSgenome.Mmusculus.UCSC.mm10))

# Load default settings
source('settings.R')
#source('utils.R')

######################
## Define arguments ##
######################

p <- ArgumentParser(description='')
p$add_argument('--indir',  type="character",              help='Input directory')
p$add_argument('--outdir',  type="character",              help='Output directory')
p$add_argument('--bedGraphToBigWig',  type="character",              help='bedGraphToBigWig binary')
#p$add_argument('--genome_seq',  type="character",              help='Genome sequence file')
p$add_argument('--samples',  type="character", nargs="+",  help='Samples to generate bigwig, pattern indir/{sample}.tsv.gz')
# p$add_argument('--window_size',  type="integer",              help='Window size')
p$add_argument('--step_size',  type="integer",              help='Step size')
p$add_argument('--min_rate_bigwig',  type="integer",              help='Minimum rate for the bigwig file')
p$add_argument('--smooth_rates', action="store_true",             help='Smooth rates?')
p$add_argument('--test', action="store_true",             help='Test mode? subset number of cells')
p$add_argument('--basedir',  type="character",    help='base directory')
p$add_argument('--genome_size_ref',  type="character",    help='genome size reference to run bedGraphToBigWig')

# Read arguments
args <- p$parse_args(commandArgs(TRUE))
io$basedir <-args$basedir
io$met_data_raw <- paste0(io$basedir, "/met/cpg_level")
io$acc_data_raw <- paste0(io$basedir, "/acc/gpc_level")

#####################
## Define settings ##
#####################

## START TEST ##
# args <- list()
# args$indir <- file.path(io$basedir,"met/cpg_level/pseudobulk/stage")
# args$outdir <- file.path(io$basedir,"met/bigwig")
# args$bedGraphToBigWig_binary <- "/n/app/bcbio/tools/bin/bedGraphToBigWig"
# args$samples <- NULL
# args$step_size <- 500
# args$min_rate_bigwig <- 10
# args$smooth_rates <- TRUE
# args$test <- FALSE
## END TEST ##

# Sanity checks
stopifnot(args$context %in% c("CG","GC"))

# I/O
dir.create(args$outdir, showWarnings=F)

# Options
if (length(args$samples)==0) {
  print(sprintf("Samples not provided. Reading samples from %s ...",args$indir))
  args$samples <- list.files(args$indir, pattern="(.tsv.gz)$") %>% gsub(".tsv.gz","",.)
  print(args$samples)
} else {
  stopifnot(args$samples%in%gsub(".tsv.gz","",list.files(args$indir, pattern="(.tsv.gz)$")))
}

if (args$test) {
  print("Test mode activated, using only one sample and subsetting to chr1...")
  args$samples <- args$samples[1] 
  sel_chr <- c("chr1")
}

#############################
## Load genome coordinates ##
#############################

genome <- fread(args$genome_size_ref) %>%
  setnames(c("chr","length"))

sel_chr <- genome$chr
#print(genome)
print(sel_chr)
# genome <- seqinfo(BSgenome.Mmusculus.UCSC.mm10)[sel_chr] %>% 
#   as.data.table(keep.rownames = T) %>% .[,c(1,2)] %>% setnames(c("chr","length"))

###########################
## Create running window ##
###########################

genomic_windows.dt <- sel_chr %>%  map(function(x) 
  data.table(chr=x, start=seq(from=1, to=genome[chr==x,length], by=args$step_size)) %>% 
    # .[,end:=start+args$window_size] %>%
    .[,end:=start+args$step_size-1] %>%
    .[,c("start","end"):=list(as.integer(start),as.integer(end))]
) %>% rbindlist %>% setkey(chr,start,end)

#####################################################
## Load pseudobulk data, overlap and export bigwig ##
#####################################################

for (i in args$samples) {

  print(i)
  
  # Load data
  data.dt <- fread(sprintf("%s/%s.tsv.gz",args$indir,i), showProgress = F) %>%
      .[,c("chr","pos","rate")] %>%
      .[chr%in%sel_chr & !is.na(pos)] %>% 
      .[,c("start","end"):=pos] %>% .[,pos:=NULL] %>%
    setkey(chr,start,end)
  
  # Overlap and quantify rates per genomic window
  tmp <- foverlaps(data.dt, genomic_windows.dt) %>%
    .[,.(rate=as.integer(round(mean(rate),0))), by=c("chr","start","end")] %>%
    setorder(chr,start,end)
  
  # Smooth rates
  if (args$smooth_rates)  {
    tmp %>% 
      .[,rolling_mean:=round(frollmean(rate,n=3, align="center"),0)] %>% 
      .[is.na(rolling_mean),rolling_mean:=rate] %>%
      .[,rate:=NULL] %>% setnames("rolling_mean","rate")
  }
  
  # Cap rates
  tmp %>% .[rate<args$min_rate_bigwig,rate:=args$min_rate_bigwig]
  
  # # zscor (added by SW)
  # tmp %>% .[,rate:=(rate-mean(rate))/sd(rate)]
    
  # Sanity checks
  stopifnot(tmp$end-tmp$start>0)
  
  # Save
  fwrite(tmp, file.path(args$outdir,sprintf("%s.bedgraph",i)), sep="\t", col.names=F, quote=F)
  #write.table(genome, file= args$genome_size_ref, quote=FALSE, sep='\t', col.names = FALSE, row.names=FALSE)
  
  # Convert to bigwig
  system(sprintf("%s %s/%s.bedgraph %s %s/%s.bw",args$bedGraphToBigWig,args$outdir,i,args$genome_size_ref,args$outdir,i))
  
  # Check that bigwig file exists
  stopifnot(file.exists(file.path(args$outdir,sprintf("%s.bw",i))))
  
  # Remove bedgraph
  file.remove(file.path(args$outdir,sprintf("%s.bedgraph",i)))
  
}


# Completion token
file.create(file.path(args$outdir,"completed.txt"))
