%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1
%   vector of centroid assignments (i.e. each entry in range [1..K])

function idx = findClosestCentroids(X, centroids)

	idx = zeros(size(X, 1), 1);

	for i = 1:size(X, 1)
		D = sum(bsxfun(@minus, centroids, X(i, :)) .^ 2, 2);
		[ idx(i), foo ] = find(D == min(D(:)), 1);
	end

end

