import pandas as pd
import numpy as np
import QSTK.qstkutil.qsdateutil as du
import datetime as dt
import QSTK.qstkutil.DataAccess as da
import matplotlib.pyplot as plt


ROLLING_WINDOW = 20
N_STD_FACTOR = 2

dt_start = dt.datetime(2010, 1, 1)
dt_end = dt.datetime(2010, 12, 31)
ldt_timestamps = du.getNYSEdays(dt_start, dt_end, dt.timedelta(hours=16))

dataobj = da.DataAccess('Yahoo')
ls_symbols = ['AAPL', 'GOOG', 'IBM', 'MSFT']

ls_keys = ['open', 'high', 'low', 'close', 'volume', 'actual_close']
ldf_data = dataobj.get_data(ldt_timestamps, ls_symbols, ls_keys)
d_data = dict(zip(ls_keys, ldf_data))

for s_key in ls_keys:
	d_data[s_key] = d_data[s_key].fillna(method='ffill')
	d_data[s_key] = d_data[s_key].fillna(method='bfill')
	d_data[s_key] = d_data[s_key].fillna(1.0)

df_close = d_data['actual_close']

# Create empty dataframe
df_columns = np.concatenate((['Date'], ls_symbols))
df = pd.DataFrame(index=range(len(ldt_timestamps)), columns=df_columns)
df['Date'] = ldt_timestamps

for s_sym in ls_symbols:

	# Calculate rolling mean and rolling std
	close_price = df_close[s_sym]
	rolling_mean = pd.rolling_mean(close_price, window=ROLLING_WINDOW)
	rolling_std = pd.rolling_std(close_price, window=ROLLING_WINDOW)

	# Calculate upper and lower Bollinger bands
	upper_bollinger = rolling_mean + rolling_std * N_STD_FACTOR
	lower_bollinger = rolling_mean - rolling_std * N_STD_FACTOR

	# Calculate normalized Bollinger values
	normalized_bollinger_values = (close_price - rolling_mean) / (rolling_std * N_STD_FACTOR)
	normalized_upper_values = normalized_bollinger_values > 1
	normalized_lower_values = normalized_bollinger_values < -1

	# Get dates where Bollinger values are not in the interval [-1, 1]
	normalized_upper_dates = [val for val, valmask in zip(ldt_timestamps, normalized_upper_values) if valmask]
	normalized_lower_dates = [val for val, valmask in zip(ldt_timestamps, normalized_lower_values) if valmask]

	#
	# Plot benchmark
	#
	plt.clf()

	# Plot close price and Bollinger bands
	plt.subplot(2, 1, 1)
	plt.plot(ldt_timestamps, close_price)
	plt.fill_between(ldt_timestamps, lower_bollinger, upper_bollinger, facecolor='lightgray', edgecolor='gray')
	for date in normalized_upper_dates:
		plt.axvline(date, color='red', linewidth=0.1)
	for date in normalized_lower_dates:
		plt.axvline(date, color='green', linewidth=0.1)
	plt.legend([s_sym])
	plt.ylabel('Adjusted Close')
	plt.xlabel('Date')

	# Plot normalized Bollinger values
	plt.subplot(2, 1, 2)
	plt.plot(ldt_timestamps, normalized_bollinger_values)
	for date in normalized_upper_dates:
		plt.axvline(date, color='red', linewidth=0.1)
	for date in normalized_lower_dates:
		plt.axvline(date, color='green', linewidth=0.1)
	plt.fill_between(ldt_timestamps, np.ones(len(ldt_timestamps)), np.zeros(len(ldt_timestamps)) - 1, facecolor='lightgray', edgecolor='gray')
	plt.ylabel('Bollinger Feature')
	plt.xlabel('Date')
	# Fix x axis range to fit with the plot above
	plt.xlim(xmin=ldt_timestamps[0])

	# Save the plot
	plt.savefig('Homework 5 - bollinger ' + str(s_sym) + '.pdf', format='pdf')

	# Store the data for the symbol in the data frame
	df[s_sym] = normalized_bollinger_values.values

# Output the data
pd.set_option('display.max_rows', len(df))
print df
