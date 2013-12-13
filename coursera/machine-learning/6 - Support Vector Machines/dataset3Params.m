%EX6PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = EX6PARAMS(X, y, Xval, yval) returns your choice of C and
%   sigma. You should complete this function to return the optimal C and
%   sigma based on a cross-validation set.

function [C, sigma] = dataset3Params(X, y, Xval, yval)

	test_array = [ 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30 ];
	N = length(test_array);

	% Error matrix
	E = zeros(N, N);

	for i = 1:N
		for  j = 1:N

			model= svmTrain(X, y, test_array(i), @(x1, x2) ...
			                gaussianKernel(x1, x2, test_array(j)));
			predictions = svmPredict(model, Xval);
			E(i, j) = mean(double(predictions ~= yval));

		end
	end

	[ C_index, sigma_index, foo ] = find(E == min(E(:)));

	C = test_array(C_index);
	sigma = test_array(sigma_index);

end
