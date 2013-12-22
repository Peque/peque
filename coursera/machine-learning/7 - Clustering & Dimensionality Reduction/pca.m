%PCA Run principal component analysis on the dataset X
%   [U, S, X] = pca(X) computes eigenvectors of the covariance matrix of X
%   Returns the eigenvectors U, the eigenvalues (on diagonal) in S

function [U, S] = pca(X)

	m = size(X, 1);

	C = 1 / m * X' * X;  % Covariance matrix
	[U, S, V] = svd(C);  % Singular value decomposition

end
