import json
import matplotlib.pyplot as plt

with open('optimization_log.json') as f:
    log = json.load(f)
iters = [r['iteration'] for r in log['iterations']]
cells = [r['ppa']['cell_count'] for r in log['iterations']]
levels = [r['ppa']['logic_levels'] for r in log['iterations']]
plt.figure(figsize=(8,4))
plt.plot(iters, cells, marker='o', label='Cell count')
plt.plot(iters, levels, marker='s', label='Logic levels')
plt.xlabel('Iteration')
plt.ylabel('Metric')
plt.title('LLM-Yosys PPA Optimization Trajectory')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig('ppa_trajectory.pdf')
plt.show()
