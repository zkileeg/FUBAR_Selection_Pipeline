#!/usr/bin/env nextflow

/*
 * Perform pervasive positive selection analysis with fubar  
 */


// Script will take as input a phylogenetic tree and an MSA of cds sequences for each gene 


//output will be a json file containing information about the rates of selection across the gene 
// FUBAR is a site-directed codon model

process run_fubar {

	
	

	conda './modules/hyphy_env.yaml' 

	publishDir './workdir', mode: 'copy' 

	input: 
	   path input_cds_alignment 
	   path input_tree 

	output:
	   path "${input_cds_alignment}.FUBAR.json"

	script:
	"""
	hyphy fubar --alignment "${input_cds_alignment}" --tree "${input_tree}" 
	"""

}
