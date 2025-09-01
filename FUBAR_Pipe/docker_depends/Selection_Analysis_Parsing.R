#Selection_Analysis_Parsing.R
#Takes as input folder with any number of json files (output of FUBAR)
#Takes the json files and separates them into a readable table with the number of pos/neg sites and the rate of selection gene wide
#Normalizes this based on the number of sites (gene length essentially) 

######################
#Load requisite libraries
library(rjson)
library(dplyr)
library(stringr)
library(phylotools)

######################
args = commandArgs(TRUE) #get the arguments sent in from the previous script. Needed as this is part of a pipeline. 
#get input directory where the files are
#selection_dir = args[1]
#input_files = list.files(selection_dir, pattern="*.json$", full.names=FALSE)

#files = args[1]
#print(args)

input_files = args[1:length(args)-1] 

#print(c("Length of arguments", args, length(args)))
#print(c(files, length(files)))
#print(c("Length of input files is now", length(input_files)))

#input_files = as.list(args[1])
output_dir = args[length(args)]

#print(input_files)
#print(class(input_files))

#initialize the output matrices 
output_matrix = matrix(nrow=length(input_files), ncol=4)
colnames(output_matrix) = c("Gene", "Num_Pos_Sites", "Num_Neg_Sites", "Ratio")

output_matrix_normalized = output_matrix

#initialize output matrix for substitution rate matrices gene wide
substitution_rate_matrix = matrix(nrow=length(input_files), ncol=2)
colnames(substitution_rate_matrix) = c("Syn_rate", "NonSyn_Rate")
rownames(substitution_rate_matrix) = input_files

substitution_rate_matrix_normalized = substitution_rate_matrix

filter_cutoff = 0.90    ####this is a decimal posterior probability. max is 1. 


#loop over all the json files in the input. We need to combine them all at the end, but parse each individually first

for (i in 1:length(input_files)){
  
   #print(paste("Selection: ", input_files[i], sep=""))
  
 
  #I had a thing to make the names nicer, but eh w/e. It works weird with different inputs. 
  #gene_name = str_replace(basename(input_files[i]), "_.*","")
  gene_name = input_files[i]
  
  #get json of selection 
  selection_json = rjson::fromJSON(file=input_files[i])
  
  #get number of sites being tested in each section
  gene_length = selection_json$input$`number of sites`
  
  
  #from the input json, parse out the necessary data 
  selection_df = as.data.frame(t(as.data.frame(selection_json$MLE$content$`0`)))
  rownames(selection_df)=c(1:nrow(selection_df))
  selection_df = cbind(selection_df, rownames(selection_df)) 
  colnames(selection_df) = c("alpha", "beta", "beta-alpha, mean posterior beta-alpha", "negative", "positive", "bayes_factor", "null1", "null2", "Position")
  
  
  #get total number of positive and negative selected sites gene wide
  pos_sites = selection_df %>% filter(positive > filter_cutoff)
  
  neg_sites = selection_df %>% filter(negative > filter_cutoff)
  
  #get the ratio  
  selection_ratio = nrow(pos_sites)/nrow(neg_sites)
    
    
  #check if there are any positive sites in the json. If it's empty, then default to putting nothing in the output. 
  if (selection_json$MLE$content$`0`[1]!="NULL"){
    
    ####output section
    
    output_matrix[i,1:4] = c(gene_name, (nrow(pos_sites)), (nrow(neg_sites)), selection_ratio)
    
    #add the sites found under selection to the output matrix. Here we divide the value of each by the feature length to get a "rate of positive/negatively selected sites per site" 
    output_matrix_normalized[i,1:4] = c(gene_name, (nrow(pos_sites)/gene_length), (nrow(neg_sites)/gene_length), selection_ratio)
    
  } else {
    
    pos_sites = matrix(nrow=0, ncol=9)
    colnames(pos_sites) = c("alpha", "beta", "beta-alpha, mean posterior beta-alpha", "negative", "positive", "bayes_factor", "null1", "null2", "Position")
    
    neg_sites = matrix(nrow=0, ncol=9)
    colnames(neg_sites) = c("alpha", "beta", "beta-alpha, mean posterior beta-alpha", "negative", "positive", "bayes_factor", "null1", "null2", "Position")
    
    output_matrix[i,1:4] = c(gene_name, 0, 0, 0)
    
  }
    
  
    #get the average nonsyn rate and syn rate across the genes being compared
    
    syn_sites = mean(selection_df$alpha)
    
    nonsyn_sites = mean(selection_df$beta)
    
    
    
    #put gene-wide substitution rate into matrix
    substitution_rate_matrix[i, 1:2] = c(syn_sites, nonsyn_sites)
    
    #put normalized gene-wide substitution rate into matrix
    substitution_rate_matrix_normalized[i, 1:2] = c(syn_sites/gene_length, nonsyn_sites/gene_length)
    
    
    
  #output positively selected sites
    write.csv(pos_sites, paste(input_files[i], "_posSelection.csv", sep=""))
  
  #output negatively selected sites
   write.csv(neg_sites, paste(input_files[i], "_negSelection.csv", sep=""))
  
}

#output total
write.csv(output_matrix,"Selection_All.csv", row.names=FALSE)
write.csv(output_matrix_normalized,"Selection_All_Normalized.csv", row.names=FALSE)

write.csv(substitution_rate_matrix, "Substitution_Rate.csv", row.names=TRUE)
write.csv(substitution_rate_matrix_normalized, "Substitution_Rate_Normalized.csv", row.names=TRUE)

#write.csv(output_matrix, paste(output_dir, "Selection_All.csv", sep=""), row.names=FALSE)
#write.csv(output_matrix_normalized, paste(output_dir, "Selection_All_Normalized.csv", sep=""), row.names=FALSE)

#write.csv(substitution_rate_matrix, paste(output_dir, "Substitution_Rate.csv", sep=""), row.names=TRUE)
#write.csv(substitution_rate_matrix_normalized, paste(output_dir, "Substitution_Rate_Normalized.csv", sep=""), row.names=TRUE)
