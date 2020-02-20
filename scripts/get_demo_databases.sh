#!/bin/bash
DB_DIR=$1
mkdir $1
cd $1

gsutil cp gs://gcs.public.cancerdatasci.org/cmgd/databases/uniref90_DEMO_diamond_v201901.tar.gz .
tar -xvzf uniref90_DEMO_diamond_v201901.tar.gz 

mkdir chocophlan
cd chocophlan
gsutil cp gs://gcs.public.cancerdatasci.org/cmgd/databases/DEMO_chocophlan.v201901.tar.gz .
tar -xvzf DEMO_chocophlan.v201901.tar.gz
