
rule metaflye_assembly:
    input:
        expand("data/minimap2/{sample}_non_human.fastq.gz", sample=config["SAMPLES"])
    output:
        assembly = "data/assembly/{sample}_mflye.fa",
        graph = "data/assembly/{sample}_mflye.gfa",
        info = "data/assembly/{sample}_mflye.info"
    params:
        directory("data/assembly/")
    conda:
        "conda_environments/flye.yaml"
    threads:
        1
    shell:
        """
        flye --meta -t {threads} --nano-hq {input} -o {params}
        """

# rule unzip_basecalls:
#     input:
#         expand("data/samples/{sample}.fastq.gz", sample = config["SAMPLES"])
#     output:
#         temp("data/samples/{sample}.fastq")
#     shell:
#         """
#         gzip --decompress -c {input} > {output}
#         """


rule meadaka_polish_assembly:
    input:
        assembly = expand("data/assembly/{sample}_mflye.fa", sample = config["SAMPLES"]),
        basecalls = expand("data/samples/{sample}.fastq.gz", sample = config["SAMPLES"])
    output:
        "data/assembly/{sample}_mflye_medaka.fasta"
    params:
        directory("data/assembly/")
    params:
        run = config["NANOPORE_RUN_SETTINGS"]
    threads:
        1
    conda:
        "conda_environment/medaka.yaml"
    shell:
        """
        medaka_consensus \
            -i {input.basecalls} \
            -d {input.assembly} \
            -o {output} \
            -t {threads} \
            -m {params}
        """