%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the
%   cost of using theta as the parameter for linear regression to fit the
%   data points in X and y. Returns the cost in J and the gradient in grad

function [J, grad] = linearRegCostFunction(X, y, theta, lambda)

	m = length(y);  % Number of training examples
	h = X * theta;  % Predictions of hypothesis on all samples

	J = 1 / (2 * m) * (sum((h - y) .^ 2) + lambda * sum(theta(2:size(theta, 1)) .^ 2));

	grad = 1 / m * (X' * (h - y) + lambda * [ 0; theta(2:size(theta, 1)) ]);

end
