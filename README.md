# HEXeR
Extract HEX color codes from image URLs

This package has one function:
```R
casthex(...)
```
All you have to do to use is the following:
1. install & load HEXeR from github
```R
devtools::install_github(repo = "jacobgolan/HEXeR")
library(HEXeR)
```
2. Make sure you also have the following packages
```R
library(data.table)
library(imager)
```
3. copy the url address of any image.
This website has a lot of nice palettes
https://www.schemecolor.com
```R
myurls<-c(
"https://www.schemecolor.com/wp-content/themes/colorsite/include/cc3.php?color0=001399&color1=0017a8&color2=0e26b1&pn=Matte%20Blue",
"https://www.schemecolor.com/wp-content/themes/colorsite/include/cc3.php?color0=c40233&color1=d61a3c&color2=b2022f&pn=Matte%20Red"
)
```
4. Extract the HEX codes
```R
casthex(myurls)
```
