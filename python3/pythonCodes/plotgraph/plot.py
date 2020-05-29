import pandas as pd
import matplotlib.pyplot as plt

s = pd.Series([1, 2, 3])
fig, ax = plt.subplots()
ax.legend(['A simple line'])
s.plot.bar()
fig.savefig('my_plot.png')
