
rule convert_bigwig_to_bedgraph:
    conda:
        '../envs/uscs.yml'
    input:
        'rawdata/GRO-seq/{sample}_{cell_type}_PROseq_{strand}.bw'
    output:
        'output/GRO-seq/{sample}_{cell_type}_PROseq_{strand}.bedgraph'
    shell:'''
    bigWigToBedGraph {input} {output}
    '''

rule sort_bedgrapgs:
    input:
        'output/GRO-seq/{sample}_{cell_type}_PROseq_{strand}.bedgraph'
    output:
        'output/GRO-seq/{sample}_{cell_type}_PROseq_{strand}.sorted.bedgraph'
    shell:'''
    sort -k1,1 -k2,2n {input} > {output}
    '''


rule merge_stranded_bedgraphs:
    conda:
        '../envs/bedtools.yml'
    input:
        fwd='output/GRO-seq/{sample}_{cell_type}_PROseq_plus.sorted.bedgraph',
        rev='output/GRO-seq/{sample}_{cell_type}_PROseq_minus.sorted.bedgraph'
    output:
        'output/GRO-seq/{sample}_{cell_type}_PROseq_all.bedgraph'
    params:
        cat_file = 'output/GRO-seq/{sample}_{cell_type}.cat.bedgraph'
    conda:'''
    cat {input.fwd} {input.rev} > {params.cat_file}
    bedtools merge -c -o sum -i {params.cat_file} > {output}
    '''


rule intersect_gro_seq_drip:
    conda:
        '../envs/bedtools.yml'
    input:
        all_gro='output/GRO-seq/{gro_sample}_{cell_type}.cat.bedgraph',
        drip='output/intersect/{drip_sample}.no_control.named.bed'
    output:
        'output/intersect_GRO/{drip_sample}.{gro_sample}_{cell_type}.bed'
    shell:'''
    mkdir -p output/intersect_GRO
    bedtools intersect -sorted -wa -wb -a {input.drip} -b {input.all_gro} > {output}
    '''




    