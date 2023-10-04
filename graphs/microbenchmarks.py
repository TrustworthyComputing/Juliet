#!/usr/bin/python

import matplotlib.pyplot as plt
from matplotlib import rc
import pandas as pd
import seaborn as sns


def set_style():
  paper_rc = {
      'font.family': 'serif',
      'font.serif': ['Times', 'Palatino', 'serif'],
      'font.size': 14,
      'legend.fontsize': 12,
      'xtick.labelsize': 12,
      'ytick.labelsize': 12,
      'lines.linewidth': 2,
      'lines.markersize': 11,
      'grid.linestyle': '--',
      'ytick.major.size': 0.1,
      'ytick.minor.size': 0.1,
  }
  # Set the font to be serif, rather than sans
  sns.set(font='serif', rc=paper_rc)
  sns.set_style('whitegrid', rc=paper_rc)
  sns.color_palette('colorblind')


fig = plt.figure(figsize=(8, 3))
rc('font',**{'family':'serif','serif':['Palatino']})
plt.rcParams['pdf.fonttype'] = 42

set_style()

wordSizes = ["8", "16", "32", "64"]

fib = [49.8, 99.1, 199.5, 398.6]
fibMUX = [123.3, 364.5, 1221.6, 4289.4]
fact = [100.9, 317.3, 1098.1, 4004.9]
pir = [92.7, 186.6, 373.1, 745.0]


sz = len(fib)
df = pd.DataFrame({
  "Alg": ["Fibonacci"] * sz + ["Fibonacci (no MUX)"] * sz + ["Factorial"] * sz + ["PIR"] * sz ,
  "Word Size": ['8 bits', '16 bits', '32 bits', '64 bits'] * sz,
  "Time (sec.)": fib + fibMUX + fact + pir
})

ax = sns.lineplot(x='Word Size', y='Time (sec.)', hue='Alg', style='Alg', markers=True, data=df)
ax.legend(ncol=2, loc='upper left')
ax.xaxis.grid(False)  # remove vertical axis
ax.yaxis.grid(True, linestyle='dotted')
ax.set_yscale('log')
ax.set_yticks((40, 100, 1000, 10000), minor=True)


plt.tight_layout()
plt.savefig('microbenchmarks.png', dpi=300, bbox_inches="tight", pad_inches=0.03)
