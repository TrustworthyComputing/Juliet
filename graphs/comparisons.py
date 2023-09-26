import numpy as np
import matplotlib.pyplot as plt

mydpi = 300
pltsize = (6, 2.4)

julietgpu = [ 7.13, 16.3, 50 ]
juliet = [ 88.4, 187.3, 579.8 ]
e3 = [ 1334.29, 3751, None ]
e3_extrap = [ 1334.29, 3751, 10598.4 ]
t2 = [ 303.639, 804.728, 2637.153 ]
vsp = [ 145.72, None, None ]
vsp_extrap = [ 145.72, 335.19, 1072.4992 ]
vsp_gpu_extrap = [ 33.64, 77.4, 247.7 ]


N = len(juliet)
index = np.arange(N)  # the x locations for the groups

fig, ax = plt.subplots(figsize=pltsize)

e3_extrap_trend = ax.plot(index, e3_extrap, linestyle='dashed', color='xkcd:orange', markerfacecolor='xkcd:light orange', marker='p', linewidth=2, markersize=9, alpha=0.3)
e3_trend = ax.plot(index, e3, linestyle='solid', color='xkcd:orange', markerfacecolor='xkcd:light orange', marker='p', linewidth=2, markersize=9)
t2_trend = ax.plot(index, t2, linestyle='solid', color='xkcd:dark yellow', markerfacecolor='xkcd:butter yellow', marker='^', linewidth=2, markersize=9)
vsp_extrap_trend = ax.plot(index, vsp_extrap, linestyle='dashed', color='xkcd:dark red', markerfacecolor='xkcd:light red', marker='o', linewidth=2, markersize=8, alpha=0.3)
vsp_trend = ax.plot(index, vsp, linestyle='solid', color='xkcd:dark red', markerfacecolor='xkcd:light red', marker='o', linewidth=2, markersize=8)
vsp_gpu_trend = ax.plot(index, vsp_gpu_extrap, linestyle='dashed', color='xkcd:dark grey', markerfacecolor='xkcd:light grey', marker='h', linewidth=2, markersize=8, alpha=0.3)
juliet_trend = ax.plot(index, juliet, linestyle='solid', color='xkcd:blue', markerfacecolor='xkcd:light blue', marker='D', linewidth=2, markersize=7)
juliet_gpu_trend = ax.plot(index, julietgpu, linestyle='solid', color='xkcd:green', markerfacecolor='xkcd:light green', marker='s', linewidth=2, markersize=8)

ax.set_axisbelow(True)
ax.grid(True, axis='y', which="both", linewidth = "0.3", linestyle='--')
ax.set_yscale('log')
ax.set_ylim([4, 100000])
ax.set_yticks([10, 100, 1000, 10000, 100000])
ax.set_ylabel('time (sec.)', fontsize=13)
ax.legend((juliet_trend[0],  juliet_gpu_trend[0], t2_trend[0], e3_trend[0], vsp_trend[0], vsp_gpu_trend[0]), ['Juliet', 'Juliet GPU', 'T2', 'E3', 'VSP', 'VSP GPU'], fontsize=8, ncol=3, loc='upper left')

ax.set_xticks(index)
ax.set_xlabel('Simon Block/Key size', fontsize=13)
ax.set_xticklabels(['32/64', '64/96', '128/128'])

ax.tick_params(axis='both', which='major', labelsize=11)

plt.tight_layout()
plt.savefig('./comparisons.png', dpi=mydpi, bbox_inches='tight', pad_inches=0.03)
