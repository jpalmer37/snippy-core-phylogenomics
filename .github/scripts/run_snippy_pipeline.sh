#!/bin/bash

set -eo pipefail

nextflow pull BCCDC-PHL/snippy-variants -r v0.1.0

sed -i 's/cpus = 8/cpus = 4/g' $HOME/.nextflow/assets/BCCDC-PHL/snippy-variants/nextflow.config 

nextflow run $HOME/.nextflow/assets/BCCDC-PHL/snippy-variants/main.nf \
	 -c $HOME/.nextflow/assets/BCCDC-PHL/snippy-variants/nextflow.config \
	 -profile conda \
	 --cache ${HOME}/.conda/envs \
	 --ref .github/data/assemblies/NC_000962.3.fa \
	 --fastq_input .github/data/fastq \
	 --outdir .github/data/test_output \
	 -with-report .github/data/test_output/nextflow_report.html \
 	 -with-trace .github/data/test_output/nextflow_trace.tsv
