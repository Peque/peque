import pandas as pd
import numpy as np
import math
import copy
import QSTK.qstkutil.qsdateutil as du
import datetime as dt
import QSTK.qstkutil.DataAccess as da
import QSTK.qstkutil.tsutil as tsu
import QSTK.qstkstudy.EventProfiler as ep


ROLLING_WINDOW = 20
N_STD_FACTOR = 1


def find_events(ls_symbols, d_data):
	''' Finding the event dataframe '''
	df_close = d_data['close']
	ts_market = df_close['SPY']

	print "Finding Events"

	# Creating an empty dataframe
	df_events = copy.deepcopy(df_close)
	df_events = df_events * np.NAN

	# Time stamps for the event range
	ldt_timestamps = df_close.index

	# Calculate rolling mean and rolling std
	market_close_price = ts_market
	market_rolling_mean = pd.rolling_mean(market_close_price, window=ROLLING_WINDOW)
	market_rolling_std = pd.rolling_std(market_close_price, window=ROLLING_WINDOW)

	# Calculate normalized Bollinger values
	market_norm_bvals = (market_close_price - market_rolling_mean) / (market_rolling_std * N_STD_FACTOR)

	for s_sym in ls_symbols:

		# Calculate rolling mean and rolling std
		close_price = df_close[s_sym]
		rolling_mean = pd.rolling_mean(close_price, window=ROLLING_WINDOW)
		rolling_std = pd.rolling_std(close_price, window=ROLLING_WINDOW)

		# Calculate normalized Bollinger values
		norm_bvals = (close_price - rolling_mean) / (rolling_std * N_STD_FACTOR)

		for i in range(1, len(ldt_timestamps)):
			# Calculating the Bollinger values
			norm_bval_today = norm_bvals.ix[ldt_timestamps[i]]
			norm_bval_yest = norm_bvals.ix[ldt_timestamps[i - 1]]
			market_norm_bval_today = market_norm_bvals[ldt_timestamps[i]]

			# Event is found when the actual close of the stock price drops below $5.00
			if norm_bval_yest >= -2 and norm_bval_today <= -2 and market_norm_bval_today >= 1:
				df_events[s_sym].ix[ldt_timestamps[i]] = 1

	return df_events


dt_start = dt.datetime(2008, 1, 1)
dt_end = dt.datetime(2009, 12, 31)
ldt_timestamps = du.getNYSEdays(dt_start, dt_end, dt.timedelta(hours=16))

dataobj = da.DataAccess('Yahoo')
ls_symbols = dataobj.get_symbols_from_list('sp5002012')
ls_symbols.append('SPY')

ls_keys = ['open', 'high', 'low', 'close', 'volume', 'actual_close']
ldf_data = dataobj.get_data(ldt_timestamps, ls_symbols, ls_keys)
d_data = dict(zip(ls_keys, ldf_data))

for s_key in ls_keys:
	d_data[s_key] = d_data[s_key].fillna(method='ffill')
	d_data[s_key] = d_data[s_key].fillna(method='bfill')
	d_data[s_key] = d_data[s_key].fillna(1.0)

df_events = find_events(ls_symbols, d_data)
print "Creating Study"
ep.eventprofiler(df_events, d_data, i_lookback=20, i_lookforward=20,
			s_filename='MyEventStudy.pdf', b_market_neutral=True, b_errorbars=True,
			s_market_sym='SPY')
