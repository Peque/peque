%PLOTDATA Plots the data points X and y into a new figure
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.

function plotData(X, y)

	figure;
	hold on;

	% Separate admitted and not admitted applications and plot the data
	pos_indx = find(y == 1);
	neg_indx = find(y == 0);
	plot(X(pos_indx, 1), X(pos_indx, 2), 'k+', 'LineWidth', 2);
	plot(X(neg_indx, 1), X(neg_indx, 2), 'ko', 'MarkerFaceColor', 'y');

	hold off;

end
