#!/usr/bin/env nextflow

/*
 * Align seqs that have been prepped  
 */


// Script will take as input nucleotide sequences

// output will be a multiple-sequence alignment for all the sequences in the peptide file

process mafft_align {

	container 'fubar_pipe_depends:latest'
	
	publishDir './workdir', mode: 'copy' 

	input: 
	   path input_fasta

	output:
	   path "${input_fasta}.aligned"

	script:
	"""
	mafft --auto '${input_fasta}' > "${input_fasta}.aligned"
 
	"""

}
