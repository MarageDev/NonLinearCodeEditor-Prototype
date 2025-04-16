import matplotlib.pyplot as plt 
import numpy as np
def F(t,y):
    return y - t**2 + 1

def f(t):
    return t**2+2*t+1-0.5*np.exp(t)
def Euler(I,h,CI):
    t = [I[0]]
    y = [CI]
    while t[-1] <= I[1]:
        y.append(y[-1]+F(t[-1],y[-1])*h)
        t.append(t[-1]+h)
    return t,y

def dicho(f,I,eps):
    a,b = min(I),max(I)
    while b - a > eps:
        m = (a + b) / 2 

        if f(a) * f(m) <= 0:  
            b = m
        else:  
            a = m
    return (a+b)/2,f((a+b)/2)

e = Euler([0.,3.],0.01,0.5)
print(dicho(f,[-1,1],0.0001))
plt.plot(e[0],e[1],label="solution avec euler")
t = np.linspace(-2.,3.,100)
plt.plot(t,f(t),label="solution exacte")
plt.legend()
plt.xlabel("t")
plt.ylabel("y")
plt.show()

def F2(t,yp,y):
    return -2*yp -y + t
def Euler2(I,h,CI):
    t = [I[0]]
    y = [CI[0]]
    yp = [CI[1]]
    while t[-1] <= I[1]:
        y.append(y[-1]+F2(t[-1],yp[-1],y[-1])*h)
        t.append(t[-1]+h)
    return t,y

def F2(t,yp,y):
    return -2*yp -y + t
def Euler2(I,h,CI):
    t = [I[0]]
    y = [CI[0]]
    yp = [CI[1]]
    while t[-1] <= I[1]:
        y.append(y[-1]+F2(t[-1],yp[-1],y[-1])*h)
        t.append(t[-1]+h)
    return t,y
e = Euler2([0.,3.],0.01,[1.,1.])
plt.plot(e[0],e[1],label="solution avec euler")
plt.legend()
plt.xlabel("t")
plt.ylabel("y")
plt.show()