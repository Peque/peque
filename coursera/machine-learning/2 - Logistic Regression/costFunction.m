%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

function [J, grad] = costFunction(theta, X, y)

	m = length(y);                     % Number of training examples
	h = 1. ./ (1. + exp(-X * theta));  % Predictions of hypothesis on all samples

	J = 1 / m * sum(-y .* log(h) - (1 - y) .* log(1 - h));
	grad = 1 / m * X' * (h - y);

end
