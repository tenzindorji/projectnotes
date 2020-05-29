import plotly as py
import pandas as pd
import numpy as np

from datetime import datetime
from datetime import time as dt_tm
from datetime import date as dt_date

import plotly.plotly as py
import plotly.tools as plotly_tools
import plotly.graph_objs as go

import os
import tempfile
os.environ['MPLCONFIGDIR'] = tempfile.mkdtemp()
from matplotlib.finance import quotes_historical_yahoo
import matplotlib.pyplot as plt

from scipy.stats import gaussian_kde

from IPython.display import HTML

x = []
y = []
ma = []

def moving_average(interval, window_size):
    window = np.ones(int(window_size))/float(window_size)
    return np.convolve(interval, window, 'same')

date1 = dt_date( 2014, 1, 1 )
date2 = dt_date( 2014, 12, 12 )
quotes = quotes_historical_yahoo('AAPL', date1, date2)
if len(quotes) == 0:
    print "Couldn't connect to yahoo trading database"
else:
    dates = [q[0] for q in quotes]
    y = [q[1] for q in quotes]
    for date in dates:
        x.append(datetime.fromordinal(int(date))\
                .strftime('%Y-%m-%d')) # Plotly timestamp format
    ma = moving_average(y, 10)

xy_data = go.Scatter( x=x, y=y, mode='markers', marker=dict(size=4), name='AAPL' )
# vvv clip first and last points of convolution
mov_avg = go.Scatter( x=x[5:-4], y=ma[5:-4], \
                  line=dict(width=2,color='red',opacity=0.5), name='Moving average' )
data = [xy_data, mov_avg]

py.iplot(data, filename='apple stock moving average')
