include: 'rules/download.smk'
include: 'rules/general.smk'
include: 'rules/intersect.smk'
include: 'rules/plot.smk'

wildcard_constraints:
   sample = '\w+'

import pandas as pd

DRIP_SAMPLES_FILE = 'samples/DRIP_samples.tsv'  # read DRIP bed files from tsv
drip_df = pd.read_csv(DRIP_SAMPLES_FILE, sep='\t').set_index('ags_gene', drop=False)
drip_sample_names = list(drip_df['ags_gene'])
drip_sample_names.remove('control')  # remove sample marked as control

rule all:
    input:
        'output/plots/feature_intersection_plot.png'  # output plot




