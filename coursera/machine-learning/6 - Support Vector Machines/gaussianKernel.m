%RBFKERNEL returns a radial basis function kernel between x1 and x2
%   sim = gaussianKernel(x1, x2) returns a gaussian kernel between x1 and x2
%   and returns the value in sim

function sim = gaussianKernel(x1, x2, sigma)

	% Ensure that x1 and x2 are column vectors
	x1 = x1(:);
	x2 = x2(:);

	sim = exp(- norm(x1 - x2, 2) ^ 2 / (2 * sigma ^ 2))

end
