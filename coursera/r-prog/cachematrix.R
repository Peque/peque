# The following functions are used to cache the inverse S of a matrix A in
# order to avoid recomputing S unless the original matrix A has changed.

# This function is used to create a cached inverse matrix. 4 functions allow
# to modify (set) or get (get) the value of the matrix to be inverted (A) and to
# recalculate (setinv) or get (getinv) the value of its inverse (S). When the
# function to set the value of A (set) is called, then the matrix S is no longer
# the correct inverse of A and, therefore, it is set to NULL.
makeCacheMatrix <- function(A = matrix())
{
	S <- NULL
	set <- function(B)
	{
		A <<- B
		S <<- NULL
	}
	get <- function() A
	setinv <- function(B) S <<- B
	getinv <- function() S
	list(set = set, get = get, setinv = setinv, getinv = getinv)
}


# This function returns the inverse of a matrix that was created with
# the previous function (makeCacheMatrix). Basically, if the inverse S of A
# has not been calculated yet (is NULL), or the matrix A changed recently (S is
# NULL again), then it will recalculate the inverse of A. Otherwise it will
# directly return the cached value of the inverse (A$getinv).
cacheSolve <- function(A, ...)
{
	S <- A$getinv()
	if (is.null(S)) {
		message('Computing inverse...')
		data <- A$get()
		S <- solve(data, ...)
		A$setinv(S)
	} else {
		message('Returning cached inverse...')
	}
	return(S)
}

#
# Testing the functions
#

# Creating a CacheMatrix
A <- makeCacheMatrix()
set.seed(1)
A$set(matrix(runif(9, -1, 1), 3))

# The first time, cacheSolve() computes the inverse...
cacheSolve(A)

# The second time, cacheSolve() returns the cached inverse...
cacheSolve(A)

# After changing the matrix, cacheSolve() recomputes the inverse!
A$set(matrix(runif(9, -1, 1), 3))
cacheSolve(A)
