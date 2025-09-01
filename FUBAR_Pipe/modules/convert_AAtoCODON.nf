#!/usr/bin/env nextflow

/*
 * Convert amino acid alignment to codon using pal2nal   
 */


// Script will take as input an aligned peptide file and a coding sequence files (.cds). 
// !!!!!!!!!!!!!!NAMES MUST MUCH BETWEEN THE ALIGNMENT FILE AND THE CDS FILE!!!!!!!!!!!!!
// If names don't match between cds and alignment file, then it will not work properly. 

//this script will output a multiple sequence alignment file of the cds   

process convert_AAtoCODON {

	container 'fubar_pipe_depends'
	
	publishDir './workdir', mode: 'copy' 

	input: 
	   path input_alignment
	   path input_cds

	output:
	   path "${input_alignment}.cds"

	script:
	"""
	pal2nal.pl "${input_alignment}" "${input_cds}" -output fasta > "${input_alignment}.cds" 
	"""

}
