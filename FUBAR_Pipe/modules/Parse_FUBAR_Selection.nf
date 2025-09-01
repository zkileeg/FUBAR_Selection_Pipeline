#!/usr/bin/env nextflow

/*
 * Parse json files from fubar selection analysis
 */


// Script will take as input a set of JSON files and output multiple files.
// 
// For each input json file (gene), there will be: 
//    - csv file containing info on positively selected sites
//    - csv file containing info on negatively selected sites 

// Regardless of the input number, there will be four summary files output:
//    - rate of pos/neg selection for each gene, raw output
//    - rate of pos/neg selection for each gene, normalized by the number of sites in each gene
//    - average rate of synonymous and non-synonymous substitutes gene-wide
//    - average rate of synonymous and non-synonymous subsitutiosn gene-wide normalized by number of sites 


//run the process from an R script

process Parse_FUBAR_Selection {


	container 'fubar_pipe_depends:latest'
	
	publishDir './workdir/FubarParsed/', mode: 'copy' 

	input: 
	   path input_json
	   path out_dir

	output:
	  path "*.csv"

	script:

	"""
	echo "${input_json}"
 
	Rscript /app/Selection_Analysis_Parsing.R $input_json "${out_dir}" 
 
	"""

}
