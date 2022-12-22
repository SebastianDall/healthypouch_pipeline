rule minimap2_index_hg38:
    input:
        "data/databases/hg38/GRCh38_2022_12_20.fna"
    output:
        protected("data/databases/hg38/GRCh38_2022_12_20.mmi")
    conda:
        "conda_evironments/minimap2.yaml"
    threads:
        1
    shell:
        """
        minimap2 -t {threads} -d {output} {input}
        """

rule minimap2_human:
    input:
        query = expand("data/samples/{sample}.fastq.gz", sample=config["SAMPLES"]),
        ref = "data/databases/hg38/GRCh38_2022_12_20.mmi"
    output:
        "data/minimap2/{sample}.sam"
    threads:
        1
    conda:
        "conda_evironments/minimap2.yaml"
    shell:
        """
        minimap2 -t {threads} -ax map-ont {input.ref} {input.query} > {output}
        """

rule samtools_extract_non_human:
    input:
        expand("data/minimap2/{sample}.sam", sample=config["SAMPLES"])
    output:
        "data/minimap2/{sample}_non_human.fastq.gz"
    conda:
        "conda_environments/samtools.yaml"
    shell:
        """
        samtools view -buSh -f 4 {input} | samtools fastq - | gzip -c - > {output}
        """
