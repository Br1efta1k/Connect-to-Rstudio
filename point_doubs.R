library(ade4)
data("doubs")
points <- doubs$xy
write.csv(points, "doubs_point.csv", row.names = FALSE)