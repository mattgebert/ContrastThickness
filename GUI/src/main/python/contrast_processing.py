import numpy as np
from PIL import Image, ImageQt
from scipy import stats
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
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

    mouseDown = QtCore.pyqtSignal()

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

        # TODO Colour later https://stackoverflow.com/questions/48391568/matplotlib-creating-plot-for-black-background-presentation-slides
        # self.fig.style.use('dark_background')
        # self.fig.rcParams.update({
        #     "lines.color": "white",
        #     "patch.edgecolor": "white",
        #     "text.color": "black",
        #     "axes.facecolor": "white",
        #     "axes.edgecolor": "lightgray",
        #     "axes.labelcolor": "white",
        #     "xtick.color": "white",
        #     "ytick.color": "white",
        #     "grid.color": "lightgray",
        #     "figure.facecolor": "black",
        #     "figure.edgecolor": "black",
        #     "savefig.facecolor": "black",
        #     "savefig.edgecolor": "black"})

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

        # TODO: pass as parameter, get from dropdown widget.
        cmap = plt.get_cmap('PiYG')

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



class DrawableContrastCanvas(QtWidgets.QGraphicsView):
    def __init__(self, parent=None, width=5, height=4, dpi=100):
        QtWidgets.QGraphicsView.__init__(self)
        # super(ContrastImagingCanvas, self).__init__(parent=parent, width=width, height=height, dpi=dpi)
        self.scene = QtWidgets.QGraphicsScene(self)
        QtWidgets.QGraphicsView.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        QtWidgets.QGraphicsView.updateGeometry(self)

        self.fig = matplotlib.figure.Figure(figsize=(width, height), dpi=dpi)
        self.axes = self.fig.add_subplot(111)
        self.fig.subplots_adjust(left=0, right=1, bottom=0, top=1) #leave room for colourbar by curring .right

    def clear_figure(self):
        self.axes.set_visible(False)

    def setContrastData(self, contrast_data, dpi=96):
        self.axes.cla()
        self.axes.set_visible(True)
        y = np.linspace(0,contrast_data.shape[0],contrast_data.shape[0])
        x = np.linspace(0,contrast_data.shape[1],contrast_data.shape[1])
        # levels = matplotlib.ticker.MaxNLocator(nbins=50).tick_values(contrast_data.min(), contrast_data.max())
        cmap = plt.get_cmap('PiYG')
        X,Y = np.meshgrid(x,y)
        cf = self.axes.imshow(contrast_data, interpolation="bilinear", cmap=cmap)

        #Hide pixel coordinates of image.
        self.axes.get_xaxis().set_ticks([])
        self.axes.get_yaxis().set_ticks([])
        # self.draw()
        self.repaintScene()

    def repaintScene(self):
        canvas = FigureCanvas(self.fig)
        # canvas.setGeometry(0,0,500,500)
        self.scene.addWidget(canvas)
        self.setScene(self.scene)

    def mousePressEvent(self, event):
        # print("Pressed")
        try:
            self.scene.removeItem(self.rect_item)
        except AttributeError:
            pass

        self.setMouseTracking(True)
        self.pressX = event.x()
        self.pressY = event.y()
        self.rect_item = QtWidgets.QGraphicsRectItem(QtCore.QRectF(0, 0, 0, 0))
        self.rect_item.setFlag(QtWidgets.QGraphicsItem.ItemIsMovable, True)
        self.scene.addItem(self.rect_item)
        print("Pressed at " + str(self.pressX) + "," + str(self.pressY))
        super(QtWidgets.QGraphicsView, self).mousePressEvent(event)

    def mouseReleaseEvent(self, event):
        self.releaseX = event.x()
        self.releaseY = event.y()
        self.mouseMoveEvent(event)
        self.setMouseTracking(False)
        print("Released at " + str(self.releaseX) + "," + str(self.releaseY))
        super(QtWidgets.QGraphicsView, self).mouseReleaseEvent(event)

    def mouseMoveEvent(self, event):
        currentX = event.x()
        currentY = event.y()
        # print(str(currentX) + "," + str(currentY))
        width = abs(currentX - self.pressX)
        height = abs(currentY - self.pressY)
        if currentX < self.pressX and currentY < self.pressY:
            self.rect_item.setRect(currentX, currentY, width, height)
        elif currentX < self.pressX:
            self.rect_item.setRect(currentX, self.pressY, width, height)
        elif currentY < self.pressY:
            self.rect_item.setRect(self.pressX, currentY, width, height)
        else:
            self.rect_item.setRect(self.pressX, self.pressY, width, height)
        super(QtWidgets.QGraphicsView, self).mouseMoveEvent(event)


        # https://stackoverflow.com/questions/7772080/tracking-mouse-move-in-qgraphicsscene-class


class ThresholdHistCanvas(FigureCanvas):
    def __init__(self, parent=None, width=5, height=4, dpi=100):
        self.fig = matplotlib.figure.Figure(figsize=(width, height), dpi=dpi)
        self.axes = self.fig.add_subplot(111)
        self.fig.subplots_adjust(left=0.02, right=0.98, bottom=0.1, top=0.98) #leave room for colourbar by curring .right
        self.clear_figure()
        FigureCanvas.__init__(self, self.fig)
        self.setParent(parent)
        FigureCanvas.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)

    def clear_figure(self):
        self.axes.set_visible(False)

    def setContrastData(self, contrast_data, dpi=96):
        self.axes.cla()
        self.axes.set_visible(True)

        vals = np.reshape(contrast_data,(contrast_data.shape[0]*contrast_data.shape[1],1))
        range = np.ptp(vals)
        desiredBinsPerPointOne = 16
        totalBins = int(np.floor(range/0.1 * desiredBinsPerPointOne))
        # print(totalBins)

        cf = self.axes.hist(vals, bins=totalBins)

        #Hide pixel coordinates of image.
        self.axes.get_yaxis().set_ticks([])
        self.draw()
