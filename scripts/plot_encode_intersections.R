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

    plt_1 <- ggplot(bed.df, aes(x=`V4`, group=`V8`, fill=`V8`)) + 
    geom_bar(stat='count', position='dodge', color='black') + 
    theme_pubr() + labs(x='Gene DRIP', y='Intersecting peaks', fill='Peak type')
    bed.df$drip_peak_length <- bed.df$V3 - bed.df$V2
    plt_2 <- ggplot(bed.df, aes(y=`V4`, x=drip_peak_length, fill=drip_peak_length)) +
                    geom_boxplot() + 
                    scale_fill_manual(values=c('#3c7672', '#E4AA56', '#D8485E')) + 
                    labs(x='DRIP peak length', y='AGS gene') +
                    theme_pubr()
    ggarrange(plt_1, plt_2, nrow=2, ncol=1, labels=c('A', 'B'), heights=c(2, 1))

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