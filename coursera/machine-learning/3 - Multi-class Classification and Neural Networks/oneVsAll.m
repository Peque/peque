%ONEVSALL trains multiple logistic regression classifiers and returns all
%the classifiers in a matrix all_theta, where the i-th row of all_theta
%corresponds to the classifier for label i
%   [all_theta] = ONEVSALL(X, y, num_labels, lambda) trains num_labels
%   logisitc regression classifiers and returns each of these classifiers
%   in a matrix all_theta, where the i-th row of all_theta corresponds
%   to the classifier for label i

function [all_theta] = oneVsAll(X, y, num_labels, lambda)

	m = size(X, 1);      % Number of training examples
	X = [ones(m, 1) X];  % Add ones to the X data matrix
	n = size(X, 2);      % Number of factors

	all_theta = zeros(num_labels, n);

	for c = 1:num_labels
		initial_theta = zeros(n, 1);
		options = optimset('GradObj', 'on', 'MaxIter', 50);
		[theta, cost] = fmincg(@(t)(lrCostFunction(t, X, (y == c), lambda)), ...
		                       initial_theta, options);
		all_theta(c, :) = theta;
	end

end
