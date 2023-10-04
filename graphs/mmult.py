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

ptxt = [0.099, 0.3, 0.7]
ctxt = [950.1, 3186.9, 7522.3]
ctxt_gpu = [814.7, 2749.5, 6517.3]

sz = len(ptxt)
# df = pd.DataFrame({
#   "Alg":  ["Juliet over Plaintexts (Baseline)"] * sz + ["Juliet over Ciphertexts"] * sz + ["Juliet over Ciphertexts (GPU)"] * sz,
#   "Matrices Size": ['4x4 x 4x4', '6x6 x 6x6', '8x8 x 8x8'] * sz,
#   "Time (sec.)": ptxt + ctxt + ctxt_gpu
# })

df = pd.DataFrame({
  "Alg":  ["Juliet over Plaintexts (Baseline)"] * sz + ["Juliet over Ciphertexts"] * sz,
  "Matrices Size": ['4x4 x 4x4', '6x6 x 6x6', '8x8 x 8x8'] * 2,
  "Time (sec.)": ptxt + ctxt
})

ax = sns.lineplot(x='Matrices Size', y='Time (sec.)', hue='Alg', style='Alg', markers=True, data=df, dashes = False)
ax.legend(ncol=1, loc='center left')
ax.xaxis.grid(False)  # remove vertical axis
ax.yaxis.grid(True, linestyle='dotted')
ax.set_yscale('log')
# ax.set_yticks((40, 100, 1000, 10000))


plt.tight_layout()
plt.savefig('mmult.png', dpi=300, bbox_inches="tight", pad_inches=0.03)
