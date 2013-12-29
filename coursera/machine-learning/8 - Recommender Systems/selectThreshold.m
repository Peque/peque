%SELECTTHRESHOLD Find the best threshold (epsilon) to use for selecting
%outliers
%   [bestEpsilon bestF1] = SELECTTHRESHOLD(yval, pval) finds the best
%   threshold to use for selecting outliers based on the results from a
%   validation set (pval) and the ground truth (yval).

function [bestEpsilon bestF1] = selectThreshold(yval, pval)

	bestEpsilon = 0;
	bestF1 = 0;

	stepsize = (max(pval) - min(pval)) / 1000;
	for epsilon = min(pval):stepsize:max(pval)
		
		predictions = (pval < epsilon);
		
		tp = sum(predictions & yval);        % True positives
		fp = sum(predictions & ~yval);       % False positives
		fn = sum(~predictions & yval);       % False negatives
		
		prec = tp / (tp + fp);               % Precision
		rec = tp / (tp + fn);                % Recall
		
		F1 = 2 * prec * rec / (prec + rec);  % F1 score

		if F1 > bestF1
		   bestF1 = F1;
		   bestEpsilon = epsilon;
		end
	end

end
