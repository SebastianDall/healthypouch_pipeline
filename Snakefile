configfile: "config.yaml"


# set threads
def setThreads(total_threads, threads):
    if total_threads == 1:
        new_threads = 1
    elif threads > total_threads:
        new_threads = total_threads
    elif threads < total_threads:
        new_threads = threads
    
    return new_threads



total_threads = config["THREADS"]

#### symlink rule?

#### minimap2
include: "rules/minimap2-remove_human.smk"


#### metaflye assemble sample
include: "rules/metaflye-assembly.smk"

#### 1xmedaka polishing

#### binning: - - -

####  
rule all:
    input:
        expand("data/assembly/{sample}_mflye_medaka.fasta", sample = config["SAMPLES"])

