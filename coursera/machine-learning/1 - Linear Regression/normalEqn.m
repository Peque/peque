%NORMALEQN Computes the closed-form solution to linear regression
%   NORMALEQN(X,y) computes the closed-form solution to linear
%   regression using the normal equations.

function [theta] = normalEqn(X, y)

	theta = pinv(X' * X) * X' * y;

end
