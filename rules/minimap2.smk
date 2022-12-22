
rule minimap2_index_hg38:
    input:
        "./data/databases/hg38/GRCh38_2022_12_20.fna"
    output:
        "./data/databases/hg38/GRCh38_2022_12_20.mmi"
    conda:
        "./conda_evironments/minimap2.yaml"
    shell:
        """
        minimap2 -d {output} {input}
        """

rule minimap2_human:
    input:
        query = expand("./data/samples/{sample}.fastq.gz", sample=config["SAMPLES"]),
        ref = "./data/databases/hg38/GRCh38_2022_12_20.mmi"
    output:
        "./data/minimap2/{sample}.sam"
    threads:
        1
    conda:
        "./conda_evironments/minimap2.yaml"
    shell:
        """
        minimap2 -ax map-ont {input.ref} {input.query} > {output}
        """