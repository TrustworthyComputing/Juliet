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
      'ytick.minor.size': 0.05,
  }
  # Set the font to be serif, rather than sans
  sns.set(font='serif', rc=paper_rc)
  sns.set_style('whitegrid', rc=paper_rc)
  sns.color_palette('colorblind')


fig = plt.figure(figsize=(8, 3))
rc('font',**{'family':'serif','serif':['Palatino']})
plt.rcParams['pdf.fonttype'] = 42

set_style()

juliet = [ 88.4, 187.3, 579.8 ]
juliet_gpu = [ 7.13, 16.3, 50 ]
e3 = [ 1334.29, 3751, None ]
t2 = [ 303.639, 804.728, 2637.153 ]
vsp = [ 145.72, None, None ]

e3_extrap = [ 1334.29, 3751, 10598.4 ]
vsp_extrap = [ 145.72, 335.19, 1072.4992 ]
vsp_gpu_extrap = [ 33.64, 77.4, 247.7 ]
none = [None, None, None]

sz = len(juliet)
df = pd.DataFrame({
  "Alg": ["Juliet"] * sz + ["T2"] * sz + ["Juliet GPU"] * sz + ["E$^3$"] * sz + ["VSP"] * sz + ["VSP GPU"] * sz,
  "Simon Block/Key Size": ['32/64', '64/96', '128/128'] * 6,
  "Time (sec.)": juliet + t2 + juliet_gpu + e3 + vsp + none,

  "Time (sec.) extrap": none + none + none + e3_extrap + vsp_extrap + vsp_gpu_extrap,
})

ax = sns.lineplot(x='Simon Block/Key Size', y='Time (sec.)', hue='Alg', style='Alg', markers=True, data=df, dashes = False)
ax = sns.lineplot(x='Simon Block/Key Size', y='Time (sec.) extrap', hue='Alg', style='Alg', markers=True, data=df, alpha = 0.5, legend=False)


ax.legend(ncol=3, loc='upper left')

ax.xaxis.grid(False) # remove vertical axis
ax.yaxis.grid(True, linestyle='dotted')
ax.set_yscale('log')
ax.set_ylim([5, 150000])
ax.set_yticks((10, 100, 1000, 10000, 100000))


plt.tight_layout()
plt.savefig('./comparisons.png', dpi=300, bbox_inches='tight', pad_inches=0.03)
