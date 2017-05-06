#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 27 14:13:45 2017
0:-1:density
@author: paul
"""

# basic NOMADS OpenDAP extraction and plotting script
from mpl_toolkits.basemap import Basemap
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import animation
import os
from WeatherClass import Weather
import pickle
import math
# set up the figure
#%%

mydate='20170427'
website='http://nomads.ncep.noaa.gov:9090/dods/gfs_0p25/gfs'
modelcycle='00'
resolution='0p25'
url=website+mydate+'/gfs_'+resolution+'_'+modelcycle+'z'
#os.mkdir('./data/'+mydate)
pathToSaveObj='./data/'+mydate+'.obj'

#Weather.download('http://polar.ncep.noaa.gov/waves/examples/usingpython.shtml','./test.obj')

latBound=[43,50]
lonBound=[-10+360, 360]
nbTimes=5

W=Weather.load(pathToSaveObj)
#%%
W.animateQuiver(res='c',Dline=100,density=10)
#%%

W2=Weather.load(pathToSaveObj,latBound,lonBound,nbTimes)
#%%

W=W.crop(latBound,lonBound,nbTimes)
#%%

# Plot the field using Basemap.  Start with setting the map
# projection using the limits of the lat/lon data itself:
fig = plt.figure()


m=Basemap(projection='mill',lat_ts=10,llcrnrlon=W.lon.min(), \
  urcrnrlon=W.lon.max(),llcrnrlat=W.lat.min(),urcrnrlat=W.lat.max(), \
  resolution='i')

x, y = m(*np.meshgrid(W.lon,W.lat))
velMag=np.empty(np.shape(W.u))

for t in range(np.size(W.time)) : 
    velMag[t]=(W.u[t]**2+W.v[0]**2)**0.5
m.pcolormesh(x,y,velMag[t],shading='flat',cmap=plt.cm.jet)
m.colorbar(location='right')
m.drawcoastlines()
m.fillcontinents()
m.drawmapboundary()
m.drawparallels(W.lat[0:-1:5],labels=[1,0,0,0])
m.drawmeridians(W.lon[0:-1:5],labels=[0,0,0,1])
plt.show()
#%%
fig = plt.figure()


m=Basemap(projection='mill',lat_ts=10,llcrnrlon=W.lon.min(), \
  urcrnrlon=W.lon.max(),llcrnrlat=W.lat.min(),urcrnrlat=W.lat.max(), \
  resolution='i')
          
x, y = m(*np.meshgrid(W.lon,W.lat))

plt.C=m.pcolormesh(x,y,W.v[0],shading='flat',cmap=plt.cm.jet)
plt.Q=m.quiver(x,y,W.u[0],W.v[0])

m.colorbar(location='right')
m.drawcoastlines()
m.fillcontinents()
m.drawmapboundary()
m.drawparallels(W.lat[0:-1:5],labels=[1,0,0,0])
m.drawmeridians(W.lon[0:-1:5],labels=[0,0,0,1])

def update_quiver(t,plt,u,v) :
    """method required to animate quiver and contour plot
    """
    plt.C=m.pcolormesh(x,y,W.wMag[t],shading='flat',cmap=plt.cm.jet)
    plt.Q=m.quiver(x,y,W.u[t],W.v[t])

    return plt

anim = animation.FuncAnimation(fig, update_quiver, frames=range(np.size(W.time)), fargs=(plt,W.u,W.v),
                               interval=50, blit=False)

plt.show()


#%%
# convert the lat/lon values to x/y projections.
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation

X, Y = np.mgrid[:2*np.pi:0.2,:2*np.pi:0.2]
U = np.cos(X)
V = np.sin(Y)

fig, ax = plt.subplots(1,1)
Q = ax.quiver(X, Y, U, V, pivot='mid', color='r', units='inches')

ax.set_xlim(-1, 7)
ax.set_ylim(-1, 7)

def update_quiver(num, Q, X, Y):
    """updates the horizontal and vertical vector components by a
    fixed increment on each frame
    """

    U = np.cos(X + num*0.1)
    V = np.sin(Y + num*0.1)

    Q.set_UVC(U,V)

    return Q,

# you need to set blit=False, or the first set of arrows never gets
# cleared on subsequent frames
anim = animation.FuncAnimation(fig, update_quiver, fargs=(Q, X, Y),
                               interval=10, blit=False)

plt.show()

#%%
# plot the field using the fast pcolormesh routine 
# set the colormap to jet.



# Add a coastline and axis values.

m.drawcoastlines()
m.fillcontinents()
m.drawmapboundary()
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(-180.,180.,60.),labels=[0,0,0,1])

# Add a colorbar and title, and then show the plot.

plt.title('Example 1: NWW3 Significant Wave Height from NOMADS')
plt.show()