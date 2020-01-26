#' Extract hex color codes from image url
#'
#' @return A list of hex color codes
#' @export
#based on https://stackoverflow.com/questions/54412166/extracting-top-2-3-hex-colors-from-images-in-r/54412848
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


#' @export
hex.list <- unique(unlist(lapply(team.logos, function(logo.url) {
  download.file(logo.url,'temp.png', mode = 'wb')
  img <- load.image('temp.png')
  getHexPrimaries(img)
})))
