library(ggplot2)
library(ggpubr)
library(tidyr)


read_bed_file <- function(bed.path){
    # read intersection bed file. Split the peak type into the id number
    # and the description
    df <- as.data.frame(read.table(bed.path, header=F, sep='\t'))
    for (i in 1:nrow(df)){
        pr <- process_peak_description(df[i, 8])
        df[i, 8] <- process_peak_description(df[i, 8])

    }
    df
}

process_peak_description <- function(peak_descrip){

    split <- unlist(strsplit(peak_descrip, '_'))
    descrip_only <- paste(peak_descrip[length(peak_descrip)],  collapse = ' ')
    return(descrip_only)

}

plot_features <- function(bed.df){

    ggplot(bed.df, aes(x=`V4`, group=`V8`, fill=`V8`)) + 
    geom_bar(stat='count', position='dodge', color='black') + 
    theme_pubr() + labs(x='Gene DRIP', y='Intersecting peaks', fill='Peak type')

}

main <- function(){

    args <- commandArgs(trailingOnly=T)
    bed.df <- read_bed_file(args[1])  # first arg is input intersection bed
    plt <- plot_features(bed.df)
    ggsave(args[2], plt, dpi=500, width=10, height=12)

}

if (! interactive()){
    main()
}