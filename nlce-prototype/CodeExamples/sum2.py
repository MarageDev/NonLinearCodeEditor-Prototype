import matplotlib.pyplot as plt
import numpy as np
from time import perf_counter

def somme(n):   # O(1)
    s = 0
    for i in range(n + 1):
        s += i
    return s

plt.plot(np.linspace(0, n, n + 1), ts, label="Itérative")
plt.plot(np.linspace(0, n, n + 1), tsr, label="Récursive")
plt.xlabel("n")
plt.ylabel("Temps (s)")
plt.title("Différence temps d'éxécution : Itérative / Récursive")
plt.legend()
plt.show()
