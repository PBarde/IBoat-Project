#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 27 18:11:08 2017

@author: paul
"""
import netCDF4
import pickle
import numpy as np
import math
import matplotlib.pyplot as plt
from matplotlib import animation
from mpl_toolkits.basemap import Basemap

class Weather :
    
    """
    .. class::    Weather
    
        This class is supposed to be used on GrAD's server files. No warranty however.
        class constructor,by default sets all attributes to None.
        lat, lon, time u and v must have same definition as in netCDF4 file of GrADS server.
        
        * .. attribute :: lat : 
                    
            latitude in degree: array or list comprised in [-90 : 90]
                
        * .. attribute :: lon :
            
            longitude in degree : array or list comprised in [0 : 360]
            
        * .. attribute :: time :
            
            in days : array or list. Time is given in days (GrADS gives 81 times steps of 3hours so 
            it is 10.125 days with time steps of 0.125 days)
            
        * .. attribute :: u :
            
            velocity toward east in m/s. Must be of shape (ntime, nlat, nlon) 
            
        * .. attribute :: v :
            
            velocity toward north.
            
        * .. method :: load 
            
            loads a Weather object (see doc)
        
        * .. method :: download
            
            downloads data from server and writes it to Weather object (see doc)
            
        * .. method :: crop
            
            returns a cropped Weather object's data to the selected range of lon,lat and time steps (see doc)
            
        * .. method :: getPolarVel 
        
            computes wind magnitude and direction and adds it to the object's attribute
        
    """

    def __init__(self,lat=None,lon=None,time=None,u=None,v=None,wMag=None,wAng=None) :
            self.lat=lat
            self.lon=lon
            self.time=time
            self.u=u
            self.v=v
            if u!=None and v!=None and wMag==None and wAng==None : 
                self.getPolarVel()
                
            
    @classmethod 
    def load(cls,path,latBound=[-90, 90],lonBound=[0, 360],nbTimes=81) :
            """
            .. method :: load 
            
                **class method**, takes a file path where an Weather object is saved and loads it into the script.
                If no lat or lon boundaries are defined it takes the whole span present in the saved object. 
                If no number of time step is defined it takes the whole span present if the saved object
                (but not more than 81 the value for GrAD files)
                
                * **path** - *string* : path to file of saved Weather object\n
                * **latBound** - *list of int* : [minlat, maxlat], the largest span is [-90,90]\n
                * **lonBound** - *list of int* : [minlon, maxlon], the largest span is [0,360]\n
                * **nbTimes** - *int* : number of frames to load
            """
            filehandler = open(path, 'rb') 
            obj = pickle.load(filehandler)
            filehandler.close()
            Cropped = obj.crop(latBound,lonBound,nbTimes)
            return Cropped
            
    @classmethod
    def download(cls,url,path,latBound=[-90, 90],lonBound=[0, 360],nbTimes=81) :
            """
            .. method :: download 
            
                **class method**, downloads Weather object from url server and writes it into path file.
            
            
                * **url** - *string* : url to server (designed for GrAD server)\n
                * **other params** : same as load method.
            
            """
            file = netCDF4.Dataset(url)
            lat  = file.variables['lat'][:]
            lon  = file.variables['lon'][:]
            time = file.variables['time'][0:nbTimes]
            #put time bounds !
            lat_inds = np.where((lat > latBound[0]) & (lat < latBound[1]))
            lon_inds = np.where((lon > lonBound[0]) & (lon < lonBound[1]))
            
            lat  = file.variables['lat'][lat_inds]
            lon  = file.variables['lon'][lon_inds]
            u = file.variables['ugrd10m'][0:nbTimes,lat_inds,lon_inds]
            v = file.variables['vgrd10m'][0:nbTimes,lat_inds,lon_inds]
            
            toBeSaved=cls(lat,lon,time,u,v)
            file.close()
            filehandler = open(path, 'wb')
            pickle.dump(toBeSaved, filehandler)
            filehandler.close()
            return toBeSaved
        
    def getPolarVel(self) : 
        """
                 .. method :: getPolarVel 
        
            computes wind magnitude and direction and adds it to the object's attribute
        """
        self.wMag=np.empty(np.shape(self.u))
        self.wAng=np.empty(np.shape(self.u))           
        for t in range(np.size(self.time)) : 
            self.wMag[t]=(self.u[t]**2+self.v[0]**2)**0.5
            for i in range(np.size(self.lat)) :
                for j in range(np.size(self.lon)) : 
                    self.wAng[t,i,j]=180/math.pi*math.atan2(self.u[t,i,j],self.v[t,i,j])
    
    def crop(self,latBound=[-90, 90],lonBound=[0, 360],nbTimes=81) :
            """
            .. method :: crop 
            
                Returns a cropped Weather object's data to the selected range of lon,lat and time steps.
                If no lat or lon boundaries are defined it takes the whole span present in the object. 
                If no number of time step is defined it takes the whole span present if the object
                (but not more than 81 the value for GrAD files)
                
                * **latBound** - *list of int* : [minlat, maxlat], the largest span is [-90,90]\n
                * **lonBound** - *list of int* : [minlon, maxlon], the largest span is [0,360]\n
                * **nbTimes** - *int* : number of frames to load
            """
            
            if (latBound!=[-90,90] or lonBound!=[0,360]) : 
                Cropped=Weather()
                lat_inds = np.where((self.lat > latBound[0]) & (self.lat < latBound[1]))
                lon_inds = np.where((self.lon > lonBound[0]) & (self.lon < lonBound[1]))
                Cropped.time=self.time[0:nbTimes]
                Cropped.lat=self.lat[lat_inds]
                Cropped.lon=self.lon[lon_inds]
                Cropped.u=np.empty((nbTimes,np.size(lat_inds),np.size(lon_inds)))
                Cropped.v=np.empty((nbTimes,np.size(lat_inds),np.size(lon_inds)))
                Cropped.wMag=np.empty((nbTimes,np.size(lat_inds),np.size(lon_inds)))
                Cropped.wAng=np.empty((nbTimes,np.size(lat_inds),np.size(lon_inds)))
                for time in range(nbTimes):
                    i=0
                    for idlat in lat_inds[0]:
                        j=0
                        for idlon in lon_inds[0]:
                            Cropped.u[time,i,j]=self.u[time,idlat,idlon]
                            Cropped.v[time,i,j]=self.v[time,idlat,idlon]
                            Cropped.wMag[time,i,j]=self.wMag[time,idlat,idlon]
                            Cropped.wAng[time,i,j]=self.wAng[time,idlat,idlon]
                            j=j+1
                        i=i+1
               

                
            elif latBound==[-90,90] and lonBound==[0,360] and nbTimes!=81 :
                Cropped=Weather()
                Cropped.time=self.time[0:nbTimes]
                Cropped.u=self.u[0:nbTimes][:][:]
                Cropped.v=self.v[0:nbTimes][:][:]
                Cropped.wMag=self.wMag[0:nbTimes][:][:]
                Cropped.wAng=self.wAng[0:nbTimes][:][:]
            
            else :
                Cropped=self
            
            return Cropped


    def plotQuiver(self, proj='mill', res='i', instant=0, Dline=5,density=1): 
        """
        to plot whole earth params should be close to res='c',Dline=100,density=10
        """
        # Plot the field using Basemap.  Start with setting the map
        # projection using the limits of the lat/lon data itself:
        plt.figure()
        
        
        m=Basemap(projection=proj,lat_ts=10,llcrnrlon=self.lon.min(), \
          urcrnrlon=self.lon.max(),llcrnrlat=self.lat.min(),urcrnrlat=self.lat.max(), \
          resolution=res)
        
        x, y = m(*np.meshgrid(self.lon,self.lat))

        m.pcolormesh(x,y,self.wMag[instant],shading='flat',cmap=plt.cm.jet)
        m.quiver(x[0:-1:density,0:-1:density],y[0:-1:density,0:-1:density],self.u[instant,0:-1:density,0:-1:density],self.v[instant,0:-1:density,0:-1:density])
        m.colorbar(location='right')
        m.drawcoastlines()
        m.fillcontinents()
        m.drawmapboundary()
        m.drawparallels(self.lat[0:-1:Dline],labels=[1,0,0,0])
        m.drawmeridians(self.lon[0:-1:Dline],labels=[0,0,0,1])
        plt.title('Wind amplitude and direction in [m/s] at time : ' + str(self.time[instant]) + ' days')
        plt.show()
        
        return plt

    def animateQuiver(self, proj='mill', res='i', instant=0, Dline=5, density=1, interval=50): 
        """
        to plot whole earth params should be close to res='c',Dline=100,density=10
        """
        # Plot the field using Basemap.  Start with setting the map
        # projection using the limits of the lat/lon data itself:
        fig=plt.figure()
        
        
        m=Basemap(projection=proj,lat_ts=10,llcrnrlon=self.lon.min(), \
          urcrnrlon=self.lon.max(),llcrnrlat=self.lat.min(),urcrnrlat=self.lat.max(), \
          resolution=res)
        
        x, y = m(*np.meshgrid(self.lon,self.lat))

        plt.C=m.pcolormesh(x,y,self.wMag[instant],shading='flat',cmap=plt.cm.jet)
        plt.Q=m.quiver(x[0:-1:density,0:-1:density],y[0:-1:density,0:-1:density],self.u[instant,0:-1:density,0:-1:density],self.v[instant,0:-1:density,0:-1:density])
        m.colorbar(location='right')
        m.drawcoastlines()
        m.fillcontinents()
        m.drawmapboundary()
        m.drawparallels(self.lat[0:-1:Dline],labels=[1,0,0,0])
        m.drawmeridians(self.lon[0:-1:Dline],labels=[0,0,0,1])
        
        def update_quiver(t,plt,self) :
            """method required to animate quiver and contour plot
            """
            plt.C=m.pcolormesh(x,y,self.wMag[instant+t],shading='flat',cmap=plt.cm.jet)
            plt.Q=m.quiver(x[0:-1:density,0:-1:density*2],y[0:-1:density,0:-1:density*2],self.u[instant+t,0:-1:density,0:-1:density*2],self.v[instant+t,0:-1:density,0:-1:density*2])
            plt.title('Wind amplitude and direction in [m/s] at time : ' + str(self.time[instant+t]) + ' days')       
            return plt
        
        anim = animation.FuncAnimation(fig, update_quiver, frames=range(np.size(self.time[instant:])), fargs=(plt,self),
                               interval=50, blit=False)

        plt.show()

        
        return anim
                    
        