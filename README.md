# Curated Metagenomics Sequencing Processing Coordinator

This repository contains:

- The pipeline itself
- A web-based coordinator and API
- Infrastructure tooling such as scripts and dockerfiles

# Included software and tooling

## The pipeline

The pipeline is a single-sample workflow written in Nextflow.

Software used in the pipeline

- humann2
  - bowtie2
  - diamond
  - biopython
  - biom-format
- metaphlan2

## API

Written in python, uses fastapi. Postgresql backend.

# Docker/Singularity

