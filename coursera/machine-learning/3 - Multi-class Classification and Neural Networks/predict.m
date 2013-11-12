%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

function p = predict(Theta1, Theta2, X)

	m = size(X, 1);
	X = [ones(m, 1) X];  % Add ones to the X data matrix


	% Calculate activation matrices
	a1 = X;

	a2 = sigmoid(a1 * Theta1');
	a2 = [ones(size(a2, 1), 1) a2];  % Add ones to the a2 matrix

	a3 = sigmoid(a2 * Theta2');


	[foo p] = max((a3), [], 2);

end
