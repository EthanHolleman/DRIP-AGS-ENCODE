import pandas as pd

DRIP_SAMPLES_FILE = 'samples/DRIP_samples.tsv'
drip_df = pd.read_csv(DRIP_SAMPLES_FILE, sep='\t').set_index('ags_gene', drop=False)
drip_sample_names = list(drip_df['ags_gene'])


rule download_encode_hmm_hmec:
    output:
        'rawdata/hg19/wgEncodeBroadHmmHmecHMM.bed'
    params:
        download_link='http://hgdownload.soe.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmmHmecHMM.bed.gz'
    shell:'''
    mkdir -p rawdata/hg19
    curl -L {params.download_link} -o {output}.gz
    gzip -d {output}.gz
    '''


rule download_drip_bed_file:
    output:
        'rawdata/drip/{sample}.bed'
    params:
        download_link= lambda wildcards: drip_df.loc[wildcards.sample, 'link']
    shell:'''
    mkdir -p rawdata/drip
    curl -L {params.download_link} -o {output}.gz
    gzip -d {output}.gz
    '''


