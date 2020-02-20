nextflow.preview.dsl=2

// need to install
//   metaphlan2 (simple download)
//   bowtie2
//   conda install diamond=0.9.19 (reported version must be one line ONLY)
//   sratoolkit
//   fastqc
// Manual python packages:
//   humann2   
//   cython
//   numpy
//   biom-format
//   Biopython

// TODO: Should we do strainphlan?
// TODO: Should we do a kmer/sketching approach?

params.in         = "SRR000237,SRR000238"
params.nucdb      = "" // chocophlan
params.protdb     = "" // uniref
params.bucket     = ""
params.run_uuid   = "this-will-be-a-uuid"


process fasterqdump {
  tag "$accession"

  input:
    val accession
  output:
    path '*.fastq'
  script:
    """fasterq-dump --split-3 --skip-technical $accession"""
}

process concat_fastq {
    input:
    path files
    output:
    path 'sample.fastq'
    script:
    """cat $files > sample.fastq"""
}

// process fastqc {
//     input:
//         path filename
//     output:
//         path '*'
//     script:
//         """fastqc $filename """
// }

process run_humann2 {

    publishDir 'gs://temp-testing/humann2_test/'

    input:
        path fastq
    output:
        path "${params.run_uuid}/*"
    // mkdir -p ${sample}/humann2
    script:
        """mkdir ${params.run_uuid} && humann2 --input ${fastq} --output ${params.run_uuid} --nucleotide-database ${params.nucdb} --protein-database ${params.protdb} --metaphlan /Users/sdavis2/git/CMGD/cmgd_coordinator/pipeline/biobakery-metaphlan2-5bd7cd0e4854/ --threads=8 && gzip -r ${params.run_uuid}"""
}


// humann2 --input ${sample}/reads/${sample}.fastq --output ${sample}/humann2 --nucleotide-database ${pc} --protein-database ${pp} --threads=${ncores}

// humann2_renorm_table --input ${sample}/humann2/${sample}_genefamilies.tsv --output ${sample}/humann2/${sample}_genefamilies_relab.tsv --units relab

// humann2_renorm_table --input ${sample}/humann2/${sample}_pathabundance.tsv --output ${sample}/humann2/${sample}_pathabundance_relab.tsv --units relab

// #python run_markers2.py --input_dir ${sample}/humann2/${sample}_humann2_temp/ --bt2_ext _metaphlan_bowtie2.txt --metaphlan_path ${pm} --metaphlan_db ${pmdb} --output_dir ${sample}/humann2 --nprocs ${ncores}

// python /home/ubuntu/curatedMetagenomicDataHighLoad/run_markers2.py --input_dir ${sample}/humann2/${sample}_humann2_temp/ --bt2_ext _metaphlan_bowtie2.txt --metaphlan_path ${pm} --metaphlan_db ${pmdb} --output_dir ${sample}/humann2 --nprocs ${ncores}

workflow {
    Channel.from( params.in.split(',')) \
    | fasterqdump \
    | collect \
    | concat_fastq \
    | run_humann2 \
    | view
}
