library("httr")
res<-GET("http://localhost:8000/echo?msg=hello")
res
POST("http://localhost:8000/sum")