#!/usr/bin/python

import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np
import sys
import string


benchmark = "microbenchmarks"

mydpi = 300
figname = benchmark+'.png'
# pltsize = (6.2, 1.96) # default (8, 6)
pltsize = (6.2, 2.1)
wordSizes = ["8", "16", "32", "64"]

data = {
    'microbenchmarks': {
        'fib' : [49.8, 99.1, 199.5, 398.6], 'fact' : [100.9, 317.3, 1098.1, 4004.9],
        'pir' : [92.7, 186.6, 373.1, 745.0], 'fibMUX' : [123.3, 364.5, 1221.6, 4289.4]
        }
}

# for key, value in data[benchmark].items():
#     for i in range(len(value)):
#         value[i] /= 1000
#     data[benchmark][key] = value


fib = data[benchmark]['fib']
fact = data[benchmark]['fact']
pir = data[benchmark]['pir']
fibMUX = data[benchmark]['fibMUX']

N = len(fib)
index = np.arange(N)  # the x locations for the groups
# width = 0.42       # the width of the bars
width = 0.22       # the width of the bars

fig, ax = plt.subplots(figsize=pltsize)
ax.margins(0.02, 0.02)

rects1 = ax.bar(index - width, fib, width, color='mediumspringgreen', hatch='ooo', edgecolor='black', linewidth=1)
rects2 = ax.bar(index, fact, width, color='cornflowerblue', hatch='...', edgecolor='black', linewidth=1)
rects3 = ax.bar(index + width, pir, width, color='lightcoral', hatch='////', edgecolor='black', linewidth=1)
rects4 = ax.bar(index + 2*width, fibMUX, width, color = 'lightpink', hatch='xxxx', edgecolor='black', linewidth=1)

ax.set_yscale('log')
ax.set_ylim([1, 10000])
ax.set_ylabel("Time (s)")
ax.set_xlabel("Word Size (bits)")
ax.set_xticks(index)
ax.set_xticklabels(wordSizes)
ax.legend((rects1[0], rects2[0], rects3[0], rects4[0]), ("Fibonacci", "Factorial", "PIR", "Fibonacci (no MUX)"), fontsize=7, ncol=2, loc='upper left')

def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        if height > 10:
            ax.text(rect.get_x() + rect.get_width()/2., 1.1*height, '%2.1f' % (height), ha='center', va='bottom', fontsize=7)
        else:
            ax.text(rect.get_x() + rect.get_width()/2., 1.1*height, '%2.1f' % (height), ha='center', va='bottom', fontsize=7)

autolabel(rects1)
autolabel(rects2)
autolabel(rects3)
autolabel(rects4)

# plt.show()

plt.tight_layout()
plt.savefig(figname,dpi=mydpi, bbox_inches="tight", pad_inches=0.03)
