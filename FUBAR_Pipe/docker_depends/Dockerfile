#Docker file containing all required packages for the FUBAR pipeline. 

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app


RUN apt-get -qq update && apt-get -qq -y install \
	r-base \
	r-base-dev \
	mafft \
	pal2nal \
	fasttree 

RUN R -e "install.packages(c('stringr', 'ape', 'dplyr'))"

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/phylotools/phylotools_0.2.2.tar.gz')"

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rjson/rjson_0.2.20.tar.gz')"

	
WORKDIR /app

COPY . /app/

 

	
