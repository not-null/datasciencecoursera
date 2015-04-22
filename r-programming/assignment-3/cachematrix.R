## makeCacheMatrix - This function creates a special "matrix" object that can cache its inverse.

##  set - This function set the value of matrix 'x' for which matrix inverse needs to be cached
#       - sets value of matrix cache 'inv' value to NULL
#       - This function can also be called directly
#       - mat <- makeCacheMatrix () 
#       - mat$set(matrix(c(1,2,3,4), nrow=2,ncol=2))

## get  - Returns the current value of matrix 'x'

## setinv   - set the inverse of matrix to 'inv' 

## getinv   - returns the inverse value of matrix 'inv'

makeCacheMatrix <- function(x = matrix()) {
    inv <- NULL
    set <- function(y) {
        x <<- y
        inv <<- NULL
    }
    get <- function() x
    setinv <- function(matrix.inv) inv <<- matrix.inv
    getinv <- function() inv
    list(set = set, get = get,
         setinv = setinv,
         getinv = getinv)
}

## This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
## If the inverse has already been calculated (and the matrix has not changed),
## then the cachesolve should retrieve the inverse from the cache.

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    
    m <- x$getinv()
    if(!is.null(m)) {
        message("getting matrix inverse from cache")
        return(m)
    }
    data <- x$get()
    m <- solve(data, ...)
    message("set new matrix inverse to cache")
    x$setinv(m)
    m 
}

## Sample Run

# mat <- makeCacheMatrix (matrix(c(1,2,3,4), nrow=2,ncol=2))
# cacheSolve(mat)
#set new matrix inverse to cache
#       [,1] [,2]
#[1,]   -2  1.5
#[2,]   1   -0.5

#cacheSolve(mat)
#getting matrix inverse from cache
#       [,1] [,2]
#[1,]   -2  1.5
#[2,]   1   -0.5

# mat <- makeCacheMatrix()
# mat$set(matrix(c(1,2,3,4), nrow=2,ncol=2))
#set new matrix inverse to cache
#       [,1] [,2]
#[1,]   -2  1.5
#[2,]   1   -0.5

#cacheSolve(mat)
#getting matrix inverse from cache
#       [,1] [,2]
#[1,]   -2  1.5
#[2,]   1   -0.5