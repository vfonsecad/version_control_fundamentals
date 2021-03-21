# --------------------------------------------------------------------------

# ----------------- intro plotting (matplotlib)
# 2021-03-23
# -------------------------------------------------------------------------


# ¡¡¡ --- !!! # ---> modules 

# --- system modules

import sys
import datetime
import os


# --- data handling modules

import numpy as np
import pandas as pd
import scipy.io as sp_io

# --- visualization modules

import matplotlib as mtply
import matplotlib.pyplot as plt

from matplotlib.cm import ScalarMappable
from matplotlib.colors import Normalize


import seaborn as sns


import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots

# (we focus today on matplotlib)

# ¡¡¡ --- !!! # ---> data

df_raw = pd.read_csv('https://goz39a.s3.eu-central-1.amazonaws.com/hepatitis_csv.csv')

# fast preprocessing, dropping na to avoid errors when plotting

df = df_raw.dropna(axis=0,how = "any")
df.columns
df.shape
df

# basic line plot


fig1 = plt.plot(np.array(df["age"])[0:50], c = "red", label = "series red")
plt.plot(np.array(df["age"])[50:], c = "blue", label = "series blue")
plt.text(-20,0,"bottom left")
plt.text(50,0,"bottom right")
plt.text(-20,100,"top left")
plt.text(50,100,"top right")
plt.title("This is the first plot")
plt.legend()
plt.grid()


plt.show()

# scatter plot


plt.scatter(np.array(df["age"]),np.array(df["bilirubin"]), c = np.array(df["protime"]), s = 100, marker='+')
plt.xlabel("age")
plt.ylabel("bilirubin")
plt.title("This is the second plot")
plt.xlim([20,70])
plt.xticks(np.linspace(25,65,8), rotation = 90)
plt.colorbar(label = "ColorbaR")
plt.grid()
plt.show()

