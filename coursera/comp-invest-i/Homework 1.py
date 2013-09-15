
import QSTK.qstkutil.qsdateutil as du
import QSTK.qstkutil.tsutil as tsu
import QSTK.qstkutil.DataAccess as da

import datetime as dt
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


def simulate(startdate, enddate, equities, allocations):

	# Date timestamps
	ldt_timestamps = du.getNYSEdays(startdate, enddate, dt.timedelta(hours = 16))

	# Data access
	c_dataobj = da.DataAccess('Yahoo')
	ls_keys = ['open', 'high', 'low', 'close', 'volume', 'actual_close']
	ldf_data = c_dataobj.get_data(ldt_timestamps, equities, ls_keys)
	d_data = dict(zip(ls_keys, ldf_data))

	# Calculate normalized close data
	close_data = d_data['close'].values
	normalized_close_data = close_data / close_data[0, :]

	# Make sure allocations is a column vector:
	allocations = np.array(allocations).reshape(len(allocations), 1)

	# Calculate portfolio close data
	portfolio_close_data = np.dot(normalized_close_data, allocations)

	# Calculate total return
	portfolio_close_data_copy = portfolio_close_data.copy()
	portfolio_normalized_cumulative_daily_return = np.sum(portfolio_close_data_copy, axis = 1)
	cum_ret = portfolio_normalized_cumulative_daily_return[-1]

	# Calculate volatility, average daily return and sharpe ratio
	portfolio_close_data_copy = portfolio_close_data.copy()
	tsu.returnize0(portfolio_close_data_copy)
	avg_daily_ret = np.mean(portfolio_close_data_copy)
	std_dev = np.std(portfolio_close_data_copy)
	sharpe = np.sqrt(252) * avg_daily_ret / std_dev

	return std_dev, avg_daily_ret, sharpe, cum_ret


startdate = dt.datetime(2010, 1, 1)
enddate = dt.datetime(2010, 12, 31)
equities = ['BRCM', 'TXN', 'AMD', 'ADI']

allocation_list = [ 0., 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1. ]

optimal_allocations = [ 0., 0., 0., 0. ]
optimal_sharpe = -np.inf

for i in allocation_list:
	for j in allocation_list:
		for k in allocation_list:
			for l in allocation_list:
				if i + j + k + l == 1:
					std_dev, avg_daily_ret, sharpe, cum_ret = simulate(startdate, enddate, equities, [ i, j, k, l])
					if sharpe > optimal_sharpe:
						optimal_sharpe = sharpe
						optimal_allocations = [ i, j, k, l ]
						optimal_avg_daily_ret = avg_daily_ret
						optimal_std_dev = std_dev
						optimal_cum_ret = cum_ret

print startdate.strftime('Start Date: %d, %b %Y')
print enddate.strftime('End Date:   %d, %b %Y')
print "Symbols: " + str(equities)
print "Optimal Allocations: " + str(optimal_allocations)
print "Sharpe Ratio: " + str(optimal_sharpe)
print "Volatility (stdev of daily returns): " + str(optimal_std_dev)
print "Average Daily Return: " + str(optimal_avg_daily_ret)
print "Cumulative Return: " + str(optimal_cum_ret)
