
rule make_feature_intersection_plot:
    conda:
        '../envs/R.yml'
    input:
        'output/intersect/all_samples_concat.intersection.bed'
    output:
        'output/plots/feature_intersection_plot.png'
    shell:'''
    mkdir -p output/plots
    Rscript scripts/plot_encode_intersections.R {input} {output}
    '''