nextflow.preview.dsl=2

params.in="hello"

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
    path 'concat.fastq'
    script:
    """cat $files > concat.fastq"""
}

process linecount {
    input:
        file filename
    output:
        file 'linecount'
    script:
        """wc -l $filename > linecount"""
}

workflow {
    Channel.from( params.in.split(',') ) \
    | fasterqdump \
    | collect \
    | concat_fastq \
    | linecount \
    | view
}
