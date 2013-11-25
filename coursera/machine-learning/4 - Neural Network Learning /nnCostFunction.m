%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.

function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)

	% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
	% for our 2 layer neural network
	Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
					 hidden_layer_size, (input_layer_size + 1));

	Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
					 num_labels, (hidden_layer_size + 1));

	m = size(X, 1);
	[ Theta1_nl, Theta1_nc ] = size(Theta1);
	[ Theta2_nl, Theta2_nc ] = size(Theta2);

	% Convert outputs to vectors
	I = eye(num_labels);
	y = I(y, :);

	% You need to return the following variables correctly
	J = 0;
	Theta1_grad = zeros(size(Theta1));
	Theta2_grad = zeros(size(Theta2));

	% Calculate activation matrices
	a1 = X;
	a1 = [ones(m, 1) a1];
	z2 = a1 * Theta1';
	a2 = sigmoid(z2);
	a2 = [ones(size(a2, 1), 1) a2];
	z3 = a2 * Theta2';
	a3 = sigmoid(z3);

	% Return cost
	J = 1 / m * sum(sum(-y .* log(a3) - (1 - y) .* log(1 - a3))) + ...
	    lambda / (2 * m) * (sum(sum(Theta1(:, 2:Theta1_nc) .^ 2)) + ...
	                        sum(sum(Theta2(:, 2:Theta2_nc) .^ 2)));

	% Error terms
	delta_3 = a3 - y;
	delta_2 = (delta_3 * Theta2(:, 2:Theta2_nc)) .* sigmoidGradient(z2);

	% Regularized gradient
	Theta2_grad = (delta_3' * a2 + lambda * [ zeros(Theta2_nl, 1) Theta2(:, 2:Theta2_nc) ]) / m;
	Theta1_grad = (delta_2' * a1 + lambda * [ zeros(Theta1_nl, 1) Theta1(:, 2:Theta1_nc) ]) / m;

	% Unroll gradients
	grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
