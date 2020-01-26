#' Extract hex color codes from image url
#'
#' @return A list of hex color codes
#' @export
casthex<-function(url){
  hex.list <- unlist(lapply(url, function(logo.url) {
    download.file(logo.url,'temp.png', mode = 'wb')
    img <- load.image('temp.png')
    function(img, pcnt.threshold = 0.05){

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

      return(hex.primaries)
    }(img)
  }))

  unlink("temp.png")
  return(hex.list)
}
