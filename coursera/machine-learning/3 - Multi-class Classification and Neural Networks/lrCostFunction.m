%LRCOSTFUNCTION Compute cost and gradient for logistic regression with
%regularization
%   J = LRCOSTFUNCTION(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters.

function [J, grad] = lrCostFunction(theta, X, y, lambda)

	m = length(y);                     % Number of training examples
	h = 1. ./ (1. + exp(-X * theta));  % Predictions of hypothesis on all samples

	J = 1 / m * sum(-y .* log(h) - (1 - y) .* log(1 - h)) + ...
	    lambda / (2 * m) * sum(theta(2:length(theta)) .^ 2);
	grad = 1 / m * X' * (h - y) + lambda / m * [ 0; theta(2:length(theta)) ];

end
