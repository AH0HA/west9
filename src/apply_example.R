# Create the matrix
m<-matrix(c(seq(from=-98,to=100,by=2)),nrow=10,ncol=10)

# Return the product of each of the rows
apply(m,1,prod)

apply(m,1,sum)

apply(m,1,max)




# Return the sum of each of the columns
apply(m,2,sum)

# Return a new matrix whose entries are those of 'm' modulo 10
apply(m,c(1,2),function(x) x%%10) 