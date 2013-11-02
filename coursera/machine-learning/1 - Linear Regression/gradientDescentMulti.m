%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)

	m = length(y);  % Number of training examples
	J_history = zeros(num_iters, 1);

	for iter = 1:num_iters

		h = X * theta;  % Predictions of hypothesis on all samples
		d = 1 / m * X' * (h - y);
		theta = theta - alpha * d;

		% Save the cost J in every iteration
		J_history(iter) = computeCost(X, y, theta);

	end

end
