#!/usr/bin/env nextflow

/*
 * Perform selection analysis with FUBAR
 */

//Pipeline is as such:
   
// 1. MSA using mafft of protein sequences 
// 2. Convert aligned sequences to codon alignment using pal2nal
// 3. Create trees using FastTree2  
// 4. Run FUBAR using the hyphy package 
// 5. Parse the output json file using an R script

// Input requirements: the pipe requires two inputs: 
//   - folder containing files of sequences to be aligned in fasta format
//   - folder containing the requisite cds sequence WITH NAMES MATCHING 

//Pipeline Params

  

include { Prep_Seqs } from './modules/Prep_Files_Selection.nf'
include { mafft_align } from './modules/mafft_align.nf'
include { convert_AAtoCODON } from './modules/convert_AAtoCODON.nf'
include { create_fasttree } from './modules/create_fasttree.nf'
include { run_fubar } from './modules/run_fubar.nf'
include { Parse_FUBAR_Selection } from './modules/Parse_FUBAR_Selection.nf'
 
//Prep_Files_Selection.nf  convert_AAtoCODON.nf  create_fasttree.nf  hyphy_env.yaml  mafft_align.nf  run_fubar.nf

workflow {


	//seq_ch = Channel.of(params.input_fasta)
	//cds_ch = Channel.of(params.input_cds)
	
	//setup two channels. One finds all fasta files in the folder
	//one finds all cds in the same or another folder 
	//input order matters so we sort the file names then emit separately 
	seq_ch = Channel.fromPath("${params.input_fasta}*.fasta").toSortedList().flatMap()
	cds_ch = Channel.fromPath("${params.input_cds}*.cds").toSortedList().flatMap()
	

	//Prep_Seqs(seq_ch)
	
	mafft_align(seq_ch)

	create_fasttree(mafft_align.output)

	convert_AAtoCODON(mafft_align.output, cds_ch)

	run_fubar(convert_AAtoCODON.output, create_fasttree.output)


	//all_ch = run_fubar.output.collect() 
	Parse_FUBAR_Selection(run_fubar.output.collect(flat: true), "$PWD/workdir/") 
}
