#!/usr/bin/python

import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np
import sys
import string


benchmark = "assorted"

mydpi = 300
figname = benchmark+'.png'
pltsize = (6, 2.4)
wordSizes = ["8", "16", "32", "64"]

data = {
    'assorted': {
        'sieve' : [64.3, 245.5, 951.7, 3684.0], 'lr' : [76.3, 273.1, 1043.6, 3976.3]
        }
}

# for key, value in data[benchmark].items():
#     for i in range(len(value)):
#         value[i] /= 1000
#     data[benchmark][key] = value


sieve = data[benchmark]['sieve']
lr = data[benchmark]['lr']

N = len(sieve)
index = np.arange(N)  # the x locations for the groups
width = 0.25       # the width of the bars

fig, ax = plt.subplots(figsize=pltsize)
ax.margins(0.04, 0.04)

rects1 = ax.bar(index - width - width/16, sieve, width, color='xkcd:light salmon', hatch='xx', edgecolor='black', linewidth=1)
rects2 = ax.bar(index + width/16, lr, width, color='xkcd:ecru', hatch='--', edgecolor='black', linewidth=1)

ax.set_yscale('log')
ax.set_ylim([10, 10000])
ax.set_ylabel("Time (s)")
ax.set_xlabel("Word Size (bits)")
ax.set_xticks(index - width / 2)
ax.set_xticklabels(wordSizes)
ax.legend((rects1[0], rects2[0]), ("Sieve of Eratosthenes", "LR Inference"), fontsize=8, ncol=1, loc='upper left')

def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        if height > 1000:
            ax.text(rect.get_x() + rect.get_width()/2., 1.1*height, '%3.0f' % (height), ha='center', va='bottom', fontsize=7)
        else:
            ax.text(rect.get_x() + rect.get_width()/2., 1.1*height, '%2.1f' % (height), ha='center', va='bottom', fontsize=7)

autolabel(rects1)
autolabel(rects2)

# plt.show()

plt.tight_layout()
plt.savefig(figname,dpi=mydpi, bbox_inches="tight", pad_inches=0.03)
