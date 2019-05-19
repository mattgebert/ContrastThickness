import numpy as np
from PIL import Image, ImageQt
from scipy import stats
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt4agg import NavigationToolbar2QT as NavigationToolbar
from PyQt5 import QtWidgets, Qt, QtCore
from mpl_toolkits.axes_grid1.axes_divider import make_axes_locatable


def create_Grayscale(filepath, r,g,b):
    #load image
    # filepath = "/home/matt/Pictures/16463120_788476604634688_6606740959182586163_o.jpg"
    img = Image.open(filepath)
    img.load()
    data = np.asarray(img,dtype="int32")
    # Create grayscale array:
    shape = data.shape #X,Y,Z
    sum = r+g+b
    if sum == 0:
        r = 0.333
        b = 0.333
        g = 0.333
    elif sum != 1.0:
        r = r/sum
        g = g/sum
        b = b/sum
        # print("The rgb coefficients do not normalize. Normalizing from " +str((r,g,b)) + " to " +  str((r/sum,g/sum,b/sum)))
    grayscale = r * data[:,:,0] + g * data[:,:,1] + b * data[:,:,2]
    return grayscale

def background_Mode(grayscale_data):
    reshaped = np.reshape(grayscale_data, -1)
    return stats.mode(reshaped)[0][0]

def background_Median(grayscale_data):
    reshaped = np.reshape(grayscale_data, -1)
    return np.median(reshaped)

def background_Mean(grayscale_data):
    return np.mean(grayscale_data)

def create_Contrast(grayscale_data, background_value):
    contrast_data = (grayscale_data - background_value) / (255-background_value)
    return contrast_data

def create_Contrast_Matplotlib(contrast_data):
    dpi = 96
    fig = plt.figure(figsize=(contrast_data.shape[0]/dpi, contrast_data.shape[1]/dpi), dpi=dpi)
    dx,dy = 1,1 #pixels for mesh
    y = np.linspace(0,contrast_data.shape[0],contrast_data.shape[0])
    x = np.linspace(0,contrast_data.shape[1],contrast_data.shape[1])

    # Z is contrast data.
    levels = matplotlib.ticker.MaxNLocator(nbins=15).tick_values(contrast_data.min(), contrast_data.max())
    cmap = plt.get_cmap('PiYG')
    norm = matplotlib.colors.BoundaryNorm(levels, ncolors=cmap.N, clip=True)
    im = plt.pcolormesh(x, y, contrast_data, cmap=cmap, norm=norm)
    fig.colorbar(im)

    # contours are *point* based plots, so convert our bound into point centers
    # cf = ax1.contourf(x + dx/2., y + dy/2., contrast_data, levels=levels,cmap=cmap)
    # fig.colorbar(cf, ax=ax1)
    return fig

class ContrastImagingCanvas(FigureCanvas):
    def __init__(self, parent=None, width=5, height=4, dpi=100):
        self.fig = matplotlib.figure.Figure(figsize=(width, height), dpi=dpi)
        self.axes = self.fig.add_subplot(111)
        self.fig.subplots_adjust(left=0.02, right=0.85, bottom=0.02, top=0.98) #leave room for colourbar by curring .right
        self.colorbar_axes = make_axes_locatable(self.axes).append_axes("right", size="5%", pad="2%")
        self.clear_figure()
        FigureCanvas.__init__(self, self.fig)
        self.setParent(parent)
        FigureCanvas.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)


    def clear_figure(self):
        self.axes.set_visible(False)
        self.colorbar_axes.set_visible(False)

    def setContrastData(self, contrast_data, dpi=96):
        self.axes.cla()
        self.axes.set_visible(True)
        self.colorbar_axes.cla()
        self.colorbar_axes.set_visible(True)
        y = np.linspace(0,contrast_data.shape[0],contrast_data.shape[0])
        x = np.linspace(0,contrast_data.shape[1],contrast_data.shape[1])
        # levels = matplotlib.ticker.MaxNLocator(nbins=50).tick_values(contrast_data.min(), contrast_data.max())
        cmap = plt.get_cmap('PiYG')
        # PColourMesh:
        # norm = matplotlib.colors.BoundaryNorm(levels, ncolors=cmap.N, clip=True)
        # im = self.axes.pcolormesh(x, y, contrast_data, cmap=cmap, norm=norm)
        # self.fig.colorbar(im)
        # ContourF:
        # cf = self.axes.contourf(X,Y, contrast_data, levels=levels, cmap=cmap)
        # cf = self.axes.contourf(X,Y, contrast_data, cmap=cmap)
        # Surface:
        # surf = self.axes.plot_surface(X,Y,contrast_data, cmap=cmap, linewidth=0, antialiased=False)
        # Pcolor:
        # cf = self.axes.pcolorfast(X, Y, contrast_data, cmap=cmap, vmin=cd_min, vmax=cd_max)
        # ImShow:
        X,Y = np.meshgrid(x,y)
        cf = self.axes.imshow(contrast_data, interpolation="bilinear", cmap=cmap)
        self.colorbar = self.fig.colorbar(cf, cax=self.colorbar_axes)
        self.colorbar_axes.tick_params(labelsize=8)

        # Invert y plotting for objects that are not "imshow"
        # limL, limR = self.axes.get_ylim()
        # self.axes.set_ylim(limR, limL)

        #Hide pixel coordinates of image.
        self.axes.get_xaxis().set_ticks([])
        self.axes.get_yaxis().set_ticks([])
        self.draw()

# %matplotlib inline
# filepath = "/home/matt/Pictures/16463120_788476604634688_6606740959182586163_o.jpg"
# img = Image.open(filepath)
# img.load()
# data = np.asarray(img,dtype="int32")
# # Create grayscale array:
# shape = data.shape #X,Y,Z
# sum = r+g+b
# if sum == 0:
#     r = 0.333
#     b = 0.333
#     g = 0.333
# elif sum != 1.0:
#     r = r/sum
#     g = g/sum
#     b = b/sum
#     # print("The rgb coefficients do not normalize. Normalizing from " +str((r,g,b)) + " to " +  str((r/sum,g/sum,b/sum)))
# grayscale = r * data[:,:,0] + g * data[:,:,1] + b * data[:,:,2]
# create_Contrast(grayscale, np.mean(grayscale))
# grayscale.shape
#
# contrast_data = grayscale
#
# fig = plt.figure()
# dx,dy = 1,1 #pixels for mesh
# x = np.linspace(0,contrast_data.shape[0],contrast_data.shape[0])
# y = np.linspace(0,contrast_data.shape[1],contrast_data.shape[1])
#
# # Z is contrast data.
# levels = matplotlib.ticker.MaxNLocator(nbins=15).tick_values(contrast_data.min(), contrast_data.max())
# cmap = plt.get_cmap('PiYG')
# norm = matplotlib.colors.BoundaryNorm(levels, ncolors=cmap.N, clip=True)
# im = plt.pcolormesh(x, y, contrast_data, cmap=cmap, norm=norm)
# fig.colorbar(im)
