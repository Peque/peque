%SIGMOID Compute sigmoid functoon
%   J = SIGMOID(z) computes the sigmoid of z.

function g = sigmoid(z)

	g = 1. ./ (1. + exp(-z));

end
