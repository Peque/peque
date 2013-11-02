%FEATURENORMALIZE Normalizes the features in X
%   FEATURENORMALIZE(X) returns a normalized version of X where the mean
%   value of each feature is 0 and the standard deviation is 1. This is
%   often a good preprocessing step to do when working with learning algorithms.

function [X_norm, mu, sigma] = featureNormalize(X)

	mu = mean(X, 1);
	sigma = std(X, 1);

	X_norm = bsxfun(@rdivide, bsxfun(@minus, X, mu), sigma);

end
