

# rule sort_drip_bed:
#     input:
#         'rawdata/drip/{sample}.bed'
#     output:
#         'rawdata/drip/{sample}.sorted.bed'
#     shell:'''
#     sort -k 1,1 -k2,2n {input} > {output}
#     '''



rule sort_hmm_states:
    conda:
        '../envs/bedtools.yml'
    input:
        'rawdata/hg19/wgEncodeBroadHmmHmecHMM.bed'
    output:
        'rawdata/hg19/wgEncodeBroadHmmHmecHMM.sorted.bed'
    shell:'''
    bedtools sort -i {input} > {output}
    '''


rule exclude_control_peaks:
    conda:
        '../envs/bedtools.yml'
    input:
        ags_bed='rawdata/drip/{sample}.bed',
        control='rawdata/drip/control.bed'
    output:
        'output/intersect/{sample}.no_control.bed'
    shell:'''
    bedtools intersect -v -a {input.ags_bed} -b {input.control} > {output}
    '''


rule add_name_column_to_treatment_bed_files:
    input:
        'output/intersect/{sample}.no_control.bed'
    output:
        'output/intersect/{sample}.no_control.named.bed'
    params:
        sample_name = lambda wildcards: wildcards['sample'].strip()
    shell:'''
    awk '{{print $1 "\t" $2 "\t" $3 "\t" "{params.sample_name}"}}' {input} > {output}
    '''


rule intersect_drip_bed_with_encode_hmm_states:
    conda:
        '../envs/bedtools.yml'
    input:
        hmm_states='rawdata/hg19/wgEncodeBroadHmmHmecHMM.sorted.bed',
        drip_bed='output/intersect/{sample}.no_control.named.bed'
    output:
        'output/intersect/{sample}.intersect.wgEncodeBroadHmmHmecHMM.bed'
    params:
        output_dir='output/intersect'
    shell:'''
    mkdir -p {params.output_dir}
    bedtools intersect -sorted -wa -wb \
    -a {input.drip_bed} -b {input.hmm_states} > {output}
    '''


rule concatenate_intersections:
    input:
        intersections=expand(
            'output/intersect/{sample}.intersect.wgEncodeBroadHmmHmecHMM.bed', 
            sample=drip_sample_names
        )
    output:
        'output/intersect/all_samples_concat.intersection.bed'
    shell:'''
    cat {input} > {output}
    '''



