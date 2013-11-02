%COMPUTECOST Compute cost for linear regression
%   J = COMPUTECOST(X, y, theta) computes the cost of using theta as the
%   parameter for linear regression to fit the data points in X and y

function J = computeCostMulti(X, y, theta)

	m = length(y);  % Number of training examples
	h = X * theta;  % Predictions of hypothesis on all samples

	J = 1 / (2 * m) * sum((h - y) .^ 2);

end
