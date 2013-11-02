%PLOTDATA Plots the data points x and y into a new figure
%   PLOTDATA(x,y) plots the data points and gives the figure axes labels
%   of population and profit.

function plotData(x, y)

	figure;  % Open a new figure window
	plot(x, y, 'rx', 'MarkerSize', 10);
	xlabel('Population of City in 10,000s');
	ylabel('Profit in $10,000s');

end
