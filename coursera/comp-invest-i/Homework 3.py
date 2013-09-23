
import pandas as pd
import datetime as dt
import matplotlib.pyplot as plt

import QSTK.qstkutil.qsdateutil as du
import QSTK.qstkutil.DataAccess as da

#
# Load orders from CSV file, and sort them by date (oldest first)
#
# We are supposing the columns are as follow:
#
#   [ Year, Month, Day, Equity, Order, Quantity ]
#
orders = pd.read_csv('orders.csv', delimiter=',', usecols = range(6), header = None)
orders.sort([0, 1, 2], ascending = [1, 1, 1], inplace = True)

#
# Get the symbol list
#
symbols = orders[3].unique()

#
# Get first and last order date
#
startdate = dt.datetime(orders.head(1)[0], orders.head(1)[1], orders.head(1)[2])
enddate = dt.datetime(orders.tail(1)[0], orders.tail(1)[1], orders.tail(1)[2])

print symbols
print orders
print startdate
print enddate

ldt_timestamps = du.getNYSEdays(startdate, enddate, dt.timedelta(hours=16))

c_dataobj = da.DataAccess('Yahoo')
ldf_data = c_dataobj.get_data(ldt_timestamps, symbols, ['close'])
d_data = dict(zip(['close'], ldf_data))

close_data = d_data['close'].values
plt.clf()
plt.plot(ldt_timestamps, close_data)
plt.legend(symbols)
plt.ylabel('Adjusted Close')
plt.xlabel('Date')
plt.savefig('Homework 3 - adjustedclose.pdf', format='pdf')
