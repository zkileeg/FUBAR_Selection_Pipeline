# FUBAR_Selection_Pipeline





<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Nextflow pipeline for calculating the rates of positive and negative selection using FUBAR from the hyphy package. 


![Flowchart](https://github.com/zkileeg/FUBAR_Selection_Pipeline/main/FUBAR_Pipe_Flowchart.png?raw=true)

<p align="right">(<a href="#readme-top">back to top</a>)</p>





<!-- GETTING STARTED -->
## Getting Started
To start, clone the repository

```
git clone https://github.com/zkileeg/FUBAR_Selection_Pipeline.git
```

### Prerequisites

* This pipeline requires nextflow, docker, and conda to work. To install: 

  Install nextflow
  ```
  sudo apt-get install nextflow
  ```
  
  Install miniconda using the guide here:
  ``` https://www.anaconda.com/docs/getting-started/miniconda/install#linux-terminal-installer ```

  And installation of docker can done here:
  ```https://docs.docker.com/engine/install/ubuntu/```


With the pre-requisities installed, you can move onto installing and testing. 

### Installation
1. Clone the repo
   ```
   git clone https://github.com/github_username/repo_name.git
   ```
3. Install dependencies from the docker file
   ```
   cd FUBAR_Pipe/docker_depends
   docker build -t fubar_pipe_depends
   ```
4. Test to make sure everything is working properly
   ```
   cd ..
   nextflow run FUBARPipe.nf --input_fasta $PWD/FastaFiles/ --input_cds $PWD/FastaFiles/
   ```
   There are two example files in the FastaFiles already. If everything is working properly, you will see outputs in ./workdir/ and ./workdir/FUBAR_Parsed/. Check to see if these files exist. 
   
5. If there is an installation error, individually check to make sure each package was installed correctly. 
   ```
   docker run -i -t fubar_pipe_depends
   mafft -h
   fasttree -h
   pal2nal.pl -h
   R
   library(phylotools)
   library(rjson)
   library(dplyr)
   library(stringr)
   ```
   Each should give a help output and give no "not found" type errors. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage
The pipe takes only two different inputs: the folder where the peptide sequences in fasta format are located, and the folder where the cds files are located.
You can substitute '$PWD/FastaFiles/' with the folder(s) your sequences are located in. 


```
nextflow run FUBARPipe.nf --input_fasta $PWD/FastaFiles/ --input_cds $PWD/FastaFiles/
```

NOTE: The peptide files MUST end in a '.fasta' extension, and the cds files MUST end in '.cds' 
<p align="right">(<a href="#readme-top">back to top</a>)</p>


