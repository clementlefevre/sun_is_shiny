# sun_is_shiny
Compute the impact of a neighbouring building on the sunlight duration in your flat.
The current version works only for Berlin coordinates, with a 5 minutes step over one year.
Use the script create.sun.position(lat,lon) function to generate your own sun data.


## installation
- start a R session ```R```
- ```library(shiny)```
- ```runApp(~/workspace/sun_is_shiny)``` assuming the app folder is located there.


## create your own sun position file for a given location
- start a R session ```R```
- ```source('sun.position.calculator.R')```
- ```create.sun.position('newyork',40.7046976,-74.0909507)```
- update the `sun.position.filename` in the `helpers.R` file.
- restart the server.


