#!/usr/bin/env nextflow

/*
 * Prep fasta files for selection analysis. 
 */


// Script will take as input 

process Prep_Seqs {

	container 'fubar_pipe_depends:latest'
	
	publishDir './', mode: 'copy' 

	input: 
	   path input_fasta

	output:
	   path "${input_fasta}_prepped.fasta"

	script:

	"""
	echo "Prepped" 
	Rscript /app/Selection_analysis_Prep_CDS.R ${input_fasta} "${input_fasta}_prepped.fasta"
 
	"""

}
