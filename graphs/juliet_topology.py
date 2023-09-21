import matplotlib.pyplot as plt
from matplotlib import rc
import pandas as pd
import seaborn as sns

def set_style():
  paper_rc = {
      'font.family': 'serif',
      'font.serif': ['Times', 'Palatino', 'serif'],
      'font.size': 13,
      'legend.fontsize': 10,
      'xtick.labelsize': 11,
      'ytick.labelsize': 11,
      'lines.linewidth': 2,
      'lines.markersize': 10,
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

bench_kogge   = [32, 30, 15, 27, 14, 21, 12, 9, 8, 15, None, None, None, None, None, None, None]
bench_ripple = [16, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]

print('bench_kogge',len(bench_kogge))
print('bench_ripple',len(bench_ripple)) # should be equal, add 0 if not

sz = len(bench_kogge)
df = pd.DataFrame({
  "Circuit Depth": [i for i in range(1, 18)] * 2,
  "Adder": ["Ripple Carry"] * sz + ["Kogge-Stone"] * sz,
  "Num. Logic Gates": bench_ripple + bench_kogge
})

ax = sns.lineplot(x='Circuit Depth', y='Num. Logic Gates', hue='Adder', style='Adder', markers=True, data=df)
ax.legend(ncol=1, loc='upper right')


plt.tight_layout()
plt.savefig("16_bit_adder_topology.png", dpi=300, bbox_inches="tight", pad_inches=0.03)
