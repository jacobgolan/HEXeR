#' Load URL
#'
#' load image URL and extract HEX codes
#'
#' @param infile Path to the input file
#' @return hex codes
#' @export
getHexPrimaries <- function(img, pcnt.threshold = 0.05){
  #convert cimg to workable format
  channel.labels <- c('R','G','B','A')[1:dim(img)[4]]
  img <- as.data.table(as.data.frame(img))
  img[,channel := factor(cc ,labels=channel.labels)]
  img <- dcast(img, x+y ~ channel, value.var = "value")
  #sort by unique rgb combinations and identify the primary colours
  colours.sorted <- img[, .N, by=list(R,G,B)][order(-N)]
  colours.sorted[ , primary := N/sum(N) > pcnt.threshold]
  #convert to hex
  hex.primaries <-
    apply(colours.sorted[primary==TRUE], 1, function(row){
      hex <- rgb(row[1], row[2], row[3], maxColorValue=1)
      hex
    })
  hex.primaries
}


#' Load image
#'
#' extract HEX codes
#'
#' @param infile Path to the input file
#' @return hex codes
#' @export
casthex<-function(x){
  unique(unlist(lapply(x,
                       function(urls){
                         download.file(urls,"temp.png",mode="wb")
                         img <- load.image('temp.png')
                         getHexPrimaries(img)
                       })))}

