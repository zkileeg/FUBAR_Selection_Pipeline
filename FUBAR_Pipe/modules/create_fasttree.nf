#!/usr/bin/env nextflow

/*
 * Infer tree using fasttree2  
 */


// Script will take as input a multiple-sequence alignment of peptides

// output will be a topological tree created by fasttree 

process create_fasttree {

	container 'fubar_pipe_depends:latest'
	
	publishDir './workdir', mode: 'copy' 

	input: 
	   path input_align

	output:
	   path "${input_align}.nwk"

	script:
	"""
	fasttree "${input_align}" > "${input_align}.nwk" 
	"""

}
