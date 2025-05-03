from time import perf_counter
import matplotlib.pyplot as plt
import numpy as np
def fact(n):
    f = 1
    for i in range(1,n+1):
        f *= i
    return f
def factRec(n):
    if n == 1 : 
        return 1
    else : 
        return n*factRec(n-1)
def fibo(n):
    f=[0,1]
    for i in range(2,n+1):
        f.append(f[-1]+f[-2])
    return f[-1]
def fiboRec(n):
    if n == 0 : 
        return 0
    elif n == 1 :
        return 1
    else : 
        return fiboRec(n-1)+fiboRec(n-2)

tf =    []  # Temps pour la fibo itérative
tfr =   []  # Temps pour la fibo récursive
n = 30
for i in range(0, n + 1):

    start = perf_counter()
    fibo(i)
    tf.append(perf_counter() - start)


    start = perf_counter()
    fiboRec(i)
    tfr.append(perf_counter() - start)
    
plt.plot(np.linspace(0, n, n + 1), tf, label="Itérative")
plt.plot(np.linspace(0, n, n + 1), tfr, label="Récursive")
plt.xlabel("n")
plt.ylabel("Temps (s)")
plt.title("Différence temps d'éxécution : Itérative / Récursive")
plt.legend()
plt.show()