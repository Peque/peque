
import numpy as np
import pandas as pd
import datetime as dt
import matplotlib.pyplot as plt

import QSTK.qstkutil.qsdateutil as du
import QSTK.qstkutil.DataAccess as da
import QSTK.qstkutil.tsutil as tsu

#
# Command line arguments (TODO)
#
orders_file = 'orders.csv'
values_file = 'values.csv'
initial_wealth = 1000000
benchmark = '$SPX'

#
# Load orders from CSV file, and sort them by date (oldest first)
#
# We are supposing the columns are as follow:
#
#   [ Year, Month, Day, Equity, Order, Quantity ]
#
def parse_date_function(year, month, day):
	return dt.datetime(year, month, day).date()

orders = pd.read_csv(orders_file, delimiter=',',
                     usecols = range(6),
                     names = ['year', 'month', 'day', 'equity', 'order', 'shares'],
                     header = None,
                     skipinitialspace = True,
                     parse_dates = {'date' : ['year', 'month', 'day']},
                     date_parser=parse_date_function)

orders.sort(['date'], ascending = [1], inplace = True)
orders.index = range(len(orders))

#
# Get the symbol list
#
symbols = orders['equity'].unique()

#
# Get first and last order date
#
startdate = orders['date'][0]
enddate = orders['date'][len(orders) - 1]

#
# Get close data
#
ldt_timestamps = du.getNYSEdays(startdate, enddate, dt.timedelta(hours=16))
c_dataobj = da.DataAccess('Yahoo')
ldf_data = c_dataobj.get_data(ldt_timestamps, symbols, ['close'])
d_data = dict(zip(['close'], ldf_data))
close_data = d_data['close'].values
close_dataframe = pd.DataFrame(close_data, range(len(close_data)), symbols)

#
# Iterate for investing
#
shares = {}
wealth_history = [None] * len(ldt_timestamps)
cash_wealth = initial_wealth
for equity in symbols:
	shares[equity] = 0
j = 0
for i in range(len(ldt_timestamps)):
	while ldt_timestamps[i].date() == orders['date'][j]:
		current_shares = orders['shares'][j]
		current_equity = orders['equity'][j]
		current_order =  orders['order'][j]
		if current_order == 'Buy':
			shares[current_equity] += current_shares
			cash_wealth -= current_shares*close_dataframe[current_equity][i]
		if current_order == 'Sell':
			shares[current_equity] -= current_shares
			cash_wealth += current_shares*close_dataframe[current_equity][i]
		j += 1
		if j == len(orders):
			break
	invested_wealth = 0
	for equity in symbols:
		invested_wealth += close_dataframe[equity][i]*shares[equity]
	total_wealth = invested_wealth + cash_wealth
	wealth_history[i] = total_wealth
	i += 1

ldf_data = c_dataobj.get_data(ldt_timestamps, [benchmark], ['close'])
d_data = dict(zip(['close'], ldf_data))
close_data = d_data['close'].values
close_data *= initial_wealth/close_data[0]

#
# Calculate sharpe ratio for our portfolio and the benchmark
#
wealth_history_vector = np.asarray(wealth_history)
wealth_history_copy = wealth_history_vector.copy()
tsu.returnize0(wealth_history_copy)
portfolio_avg_daily_ret = np.mean(wealth_history_copy)
portfolio_std_dev = np.std(wealth_history_copy)
portfolio_sharpe = np.sqrt(252) * portfolio_avg_daily_ret / portfolio_std_dev

close_data_copy = close_data.copy()
tsu.returnize0(close_data_copy)
benchmark_avg_daily_ret = np.mean(close_data_copy)
benchmark_std_dev = np.std(close_data_copy)
benchmark_sharpe = np.sqrt(252) * benchmark_avg_daily_ret / benchmark_std_dev

print "Data Range : " + str(startdate) + " to " + str(enddate)
print "Using " + benchmark + " as benchmark..."
print "Total return (portfolio): " + str(wealth_history[len(wealth_history) - 1] / initial_wealth)
print "Total return (benchmark): " + str(close_data[-1] / initial_wealth)
print "Portfolio daily return: " + str(portfolio_avg_daily_ret)
print "Benchmark daily return: " + str(benchmark_avg_daily_ret)
print "Portfolio standard deviation: " + str(portfolio_std_dev)
print "Benchmark standard deviation: " + str(benchmark_std_dev)
print "Portfolio Sharpe ratio: " + str(portfolio_sharpe)
print "Benchmark Sharpe ratio: " + str(benchmark_sharpe)

#
# Plot benchmark
#
plt.clf()
plt.plot(ldt_timestamps, wealth_history)
plt.plot(ldt_timestamps, close_data)
plt.legend(['Portfolio', '$SPX'])
plt.ylabel('Adjusted Close')
plt.xlabel('Date')
plt.savefig('Homework 3 - adjustedclose.pdf', format='pdf')
