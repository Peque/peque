%SIGMOIDGRADIENT returns the gradient of the sigmoid function
%evaluated at z
%   g = SIGMOIDGRADIENT(z) computes the gradient of the sigmoid function
%   evaluated at z. This should work regardless if z is a matrix or a
%   vector. In particular, if z is a vector or matrix, you should return
%   the gradient for each element.

function g = sigmoidGradient(z)

	g = zeros(size(z));

	g = (1. - 1. ./ (1. + exp(-z))) ./ (1. + exp(-z));

end
