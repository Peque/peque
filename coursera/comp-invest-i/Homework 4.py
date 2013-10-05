import pandas as pd
import numpy as np
import math
import copy
import QSTK.qstkutil.qsdateutil as du
import datetime as dt
import QSTK.qstkutil.DataAccess as da
import QSTK.qstkutil.tsutil as tsu
import QSTK.qstkstudy.EventProfiler as ep


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

df_close = d_data['actual_close']
ts_market = df_close['SPY']

# Creating an empty dataframe
df_events = copy.deepcopy(df_close)
df_events = df_events * np.NAN

# Time stamps for the event range
ldt_timestamps = df_close.index

# Create empty dataframe
df_columns = ['year', 'month', 'day', 'equity', 'order', 'shares']
df = pd.DataFrame(columns = df_columns)

for s_sym in ls_symbols:
	for i in range(1, len(ldt_timestamps)):
		# Calculating the returns for this timestamp
		f_symprice_today = df_close[s_sym].ix[ldt_timestamps[i]]
		f_symprice_yest = df_close[s_sym].ix[ldt_timestamps[i - 1]]

		if f_symprice_yest >= 6 and f_symprice_today < 6:
			row = pd.DataFrame([{'year': ldt_timestamps[i].year,
			                    'month': ldt_timestamps[i].month,
			                      'day': ldt_timestamps[i].day,
			                   'equity': s_sym,
			                    'order': 'Buy',
			                   'shares': 100}])
			df = df.append(row)
			sell_day = i + 5
			if sell_day >= len(ldt_timestamps):
				sell_day = len(ldt_timestamps) - 1
			row = pd.DataFrame([{'year': ldt_timestamps[sell_day].year,
			                    'month': ldt_timestamps[sell_day].month,
			                      'day': ldt_timestamps[sell_day].day,
			                   'equity': s_sym,
			                    'order': 'Sell',
			                   'shares': 100}])
			df = df.append(row)

df.to_csv('orders.csv',
          header = None,
          index = None,
          cols = df_columns)
