

###this chunk will take as input a folder where a bunch of CDS are and gets them ready for selection

library(phylotools)
library(stringr)
#library(dplyr)

args = commandArgs(TRUE)

fasta_in= args[1]
#fasta_list=list.files(directory ,pattern="*.fasta$")
output_dir= args[2]

#loops over each, checking for certain feature issues

  
if (file.size(fasta_in) > 0){
     
  print(fasta_in)
  
  fastas=read.fasta(fasta_in)
  
 
  #loop over sequences in file
  for (j in 1:nrow(fastas)){
     
      #fix start codon if it doesn't start with ATG
        start_codon = gregexpr("atg", fastas[j,2], ignore.case=TRUE)[[1]][1]
        
        fastas[j,2] = str_sub(fastas[j,2],start_codon, -1)
        
          #get last codon 
      
            last_codon=toupper(str_sub(fastas[j,2],nchar(fastas[j,2])-2, nchar(fastas[j,2])))
         
           
           if (last_codon == "TGA" | last_codon == "TAA" | last_codon == "TAG"){
             
             fastas[j,2] = str_sub(fastas[j,2],1, -4)
             
           }
           
    
          if (nchar(fastas[j,2])%%3==1){
          
            
            fastas[j,2] = str_sub(fastas[j,2],1, -2)
            
            
          }else if (nchar(fastas[j,2])%%3==2){
            
            fastas[j,2] = str_sub(fastas[j,2],1, -3)
            
          }
        
        
       
       
          
  }
  
  
  fastas$seq.name=paste(">",fastas$seq.name,sep="")
  
  write.table(fastas, output_dir, quote=FALSE, row.names = FALSE, col.names=FALSE, sep="\n")
  
  
  
 }else{
  
	warning(paste("Input file ", fasta_in, "is empty.", sep=""))
     
}

 


