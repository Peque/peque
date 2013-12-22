%KMEANSINITCENTROIDS This function initializes K centroids that are to be
%used in K-Means on the dataset X
%   centroids = KMEANSINITCENTROIDS(X, K) returns K initial centroids to be
%   used with the K-Means on the dataset X

function centroids = kMeansInitCentroids(X, K)

	randidx = randperm(size(X, 1));
	centroids = X(randidx(1:K), :);

end

