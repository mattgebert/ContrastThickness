import numpy as np
from PIL import Image, ImageQt
from scipy import stats
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
from PyQt5 import QtWidgets, QtGui, Qt, QtCore
from mpl_toolkits.axes_grid1.axes_divider import make_axes_locatable

def create_Grayscale(filepath, r,g,b):
    #load image
    # filepath = "/home/matt/Pictures/16463120_788476604634688_6606740959182586163_o.jpg"
    img = Image.open(filepath)
    img.load()
    # Convert to double precision
    data = np.asarray(img,dtype="int32") / 256.0

    # Create grayscale array:
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
    print(grayscale_data)
    contrast_data = (grayscale_data - background_value) / (1-background_value)
    print(contrast_data)
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

class ContrastFigContainer(object):
    def __init__(self, width, height, dpi):
        self.fig = matplotlib.figure.Figure(figsize=(width, height), dpi=dpi)
        self.axes = self.fig.add_subplot(111)
        self.fig.subplots_adjust(left=0, right=1, bottom=0, top=1) #leave room for colourbar by curring .right

        # Start with colourbar hidden
        self.colorbar_axes = make_axes_locatable(self.axes).append_axes("right", size="5%", pad="2%")
        self.colorbar_axes.set_visible(False)

    def set_contrast_data(self, contrast_data):
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

    def set_fig_size(self, w,h, dpi):
        # Assuming 300DPI
        self.fig.set_size_inches(w,h)
        self.fig.set_dpi(dpi)

    def hide_axes(self):
        self.axes.set_visible(False)

    def show_axes(self):
        self.axes.set_visible(True)

    def show_colourbar(self):
        self.colorbar_axes.set_visible(True)
        self.fig.subplots_adjust(left=0.02, right=0.85, bottom=0.02, top=0.98) #leave room for colourbar by curring .right

    def hide_colourbar(self):
        self.colorbar_axes.set_visible(False)
        self.fig.subplots_adjust(left=0, right=1, bottom=0, top=1) #leave room for colourbar by curring .right

class DrawableFigCanvas(QtWidgets.QGraphicsView):
    def __init__(self, parent=None, figContainer=None):

        QtWidgets.QGraphicsView.__init__(self)
        # super(ContrastImagingCanvas, self).__init__(parent=parent, width=width, height=height, dpi=dpi)
        self.setMouseTracking(False) #Stops moues tracking for 'mouseMoveEvent'
        self.scene = QtWidgets.QGraphicsScene(self)
        QtWidgets.QGraphicsView.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        QtWidgets.QGraphicsView.updateGeometry(self)

        if fig is not None:
            self.figContainer = figContainer
        else:
            self.figContainer = None

    def clear_figure(self):
        if self.figContainer is not None:
            self.figContainer.hide_axes()

    def setFigureSize(self, w,h, dpi):
        # Assuming 300DPI
        if self.figContainer is not None:
            self.figContainer.set_fig_size(w,h,dpi)
        self.fitInView(0,0,w,h, QtCore.Qt.KeepAspectRatio)

    def setContrastData(self, contrast_data):
        if self.figContainer is not None:
            self.figContainer.set_contrast_data(contrast_data)
            self.repaintScene()

    def repaintScene(self):
        if self.figContainer is not None:
            canvas = FigureCanvas(self.figContainer.fig)
            self.scene.addWidget(canvas)
            self.setScene(self.scene)
            size = self.figContainer.fig.get_size_inches()
            dpi = self.figContainer.fig.get_dpi()
            self.fitInView(0,0,size[0]*dpi, size[1]*dpi, QtCore.Qt.KeepAspectRatio)

    def mousePressEvent(self, event):
        eventX = event.x()
        eventY = event.y()
        if eventX < 0 or eventX > self.width:
            self.setPos(0, eventY)
        if eventY < 0 or eventY > self.height:
            self.getPos


        self.dragging = False
        if event.button() == QtCore.Qt.LeftButton:
            try:
                if (self.releaseY <= event.y() and self.pressY >= event.y() ) or (self.releaseY >= event.y() and self.pressY <= event.y()):
                    if (self.releaseX >= event.x() and self.pressX >= event.x() ) or (self.releaseX >= event.x() and self.pressX <= event.x()):
                        # inside range of previously defined square:
                        self.dragging = True
            except AttributeError:
                self.dragging = False
                self.pressX = event.x()
                self.pressY = event.y()
            try:
                self.scene.removeItem(self.rect_item)
            except AttributeError:
                pass

            self.setMouseTracking(True)
            if self.dragging:
                self.dragX = event.x()
                self.dragY = event.y()
                print("Dragged from " + str(self.dragX) + "," + str(self.dragY))
            else:
                self.pressX = event.x()
                self.pressY = event.y()
                self.rect_item = QtWidgets.QGraphicsRectItem(QtCore.QRectF(0, 0, 0, 0))
                self.rect_item.setFlag(QtWidgets.QGraphicsItem.ItemIsMovable, True)
                self.scene.addItem(self.rect_item)
                print("Pressed at " + str(self.pressX) + "," + str(self.pressY))
        elif event.button() == QtCore.Qt.RightButton:
            try:
                self.scene.removeItem(self.rect_item)
                self.dragging = False
            except AttributeError:
                pass
        super(QtWidgets.QGraphicsView, self).mousePressEvent(event)

    def mouseReleaseEvent(self, event):
        if event.button() == QtCore.Qt.LeftButton:
            if self.dragging:
                transX = event.x() - self.dragX
                transY = event.y() - self.dragY
                self.pressX += transX
                self.pressY += transY
                self.releaseX += transX
                self.releaseY += transY
                print("Draggged to " + str(event.x()) + "," + str(event.y()))
            else:
                self.releaseX = event.x()
                self.releaseY = event.y()
                print("Released at " + str(self.releaseX) + "," + str(self.releaseY))
            self.setMouseTracking(False) #Stops moues tracking for 'mouseMoveEvent'
            self.dragging = False
        super(QtWidgets.QGraphicsView, self).mouseReleaseEvent(event)

    def mouseMoveEvent(self, event):
        # if event.button() == QtCore.Qt.LeftButton: #Note this condition isn't valid when holding down left click...

        #  Ensure Mouse events exist only within graphicsscene:


        try:
            currentX = event.x()
            currentY = event.y()
            width = abs(currentX - self.pressX)
            height = abs(currentY - self.pressY)
            if self.dragging:
                transX = event.x() - self.dragX
                transY = event.y() - self.dragY

                if currentX < self.pressX and currentY < self.pressY:
                    self.rect_item.setRect(currentX + transX, currentY + transY, width, height)
                elif currentX < self.pressX:
                    self.rect_item.setRect(currentX + transX, self.pressY + transY, width, height)
                elif currentY < self.pressY:
                    self.rect_item.setRect(self.pressX + transX, currentY + transY, width, height)
                else:
                    self.rect_item.setRect(self.pressX + transX, self.pressY + transY, width, height)
                print("Translated " + str(transX) + "," + str(transY))
            else:
                # Only occurs during a held down click, not hovering motion. This is due to setting mouse tracking.
                if currentX < self.pressX and currentY < self.pressY:
                    self.rect_item.setRect(currentX, currentY, width, height)
                elif currentX < self.pressX:
                    self.rect_item.setRect(currentX, self.pressY, width, height)
                elif currentY < self.pressY:
                    self.rect_item.setRect(self.pressX, currentY, width, height)
                else:
                    self.rect_item.setRect(self.pressX, self.pressY, width, height)
        except AttributeError:
            self.dragging = False
            self.setMouseTracking(False) #Stops moues tracking for 'mouseMoveEvent'
        super(QtWidgets.QGraphicsView, self).mouseMoveEvent(event)
        # https://stackoverflow.com/questions/7772080/tracking-mouse-move-in-qgraphicsscene-class

class DrawableContrastCanvas(QtWidgets.QGraphicsView):

    rectangleDefined = QtCore.Signal(object)
    rectangleCleared = QtCore.Signal(object)

    def __init__(self, parent=None):
        QtWidgets.QGraphicsView.__init__(self)
        self.setMouseTracking(False) #Stops moues tracking for 'mouseMoveEvent'
        self.scene = QtWidgets.QGraphicsScene(self)
        QtWidgets.QGraphicsView.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        QtWidgets.QGraphicsView.updateGeometry(self)
        self.fig = matplotlib.figure.Figure()
        self.axes = self.fig.add_subplot(111)
        self.fig.subplots_adjust(left=0, right=1, bottom=0, top=1) #leave room for colourbar by curring .right

    def clear_figure(self):
        self.axes.set_visible(False)

    def setFigureSize(self, w,h, dpi):
        # Assuming 300DPI
        self.fig.set_size_inches(w,h)
        self.fig.set_dpi(dpi)

    def setContrastData(self, contrast_data):
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

        # Set fig size
        h = contrast_data.shape[0]
        w = contrast_data.shape[1]
        self.setFigureSize(w=w/300,h=h/300,dpi=300)
        self.repaintScene()

    def repaintScene(self):
        canvas = FigureCanvas(self.fig)
        canvas.setSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        canvas.updateGeometry()
        self.scene.addWidget(canvas)
        self.setScene(self.scene)
        # Fit into view:
        sceneRect = self.scene.sceneRect()
        # Take 10% of width extra
        adjRect = sceneRect.adjusted(-0.1 * sceneRect.width(), -0.1 * sceneRect.height(), 0.1 * sceneRect.width(),0.1*sceneRect.height())
        self.fitInView(adjRect, QtCore.Qt.KeepAspectRatio)

    def wheelEvent(self, event):
        """
        Zoom in or out of the view.
        """
        # self.setTransformationAnchor(QtWidgets.QGraphicsView.AnchorUnderMouse)
        zoomInFactor = 1.25
        zoomOutFactor = 1 / zoomInFactor

        # Set Anchors
        self.setTransformationAnchor(QtWidgets.QGraphicsView.NoAnchor)
        self.setResizeAnchor(QtWidgets.QGraphicsView.NoAnchor)

        # Save the scene pos
        oldPos = self.mapToScene(event.pos())

        # Zoom
        if event.angleDelta().y() > 0:
            zoomFactor = zoomInFactor
        else:
            zoomFactor = zoomOutFactor
        self.scale(zoomFactor, zoomFactor)

        # Get the new positions
        newPos = self.mapToScene(event.pos())

        # Move scene to old position
        delta = newPos - oldPos
        self.translate(delta.x(), delta.y())


    def mousePressEvent(self, event):
        # Record mouse position.
        sceneRect = self.scene.sceneRect()

        # When pressed, snap to area within scene.
        globalX, globalY = self.keepMouseInBounds(event)
        if globalX is not None and globalY is not None:
            mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(globalX, globalY)))
        elif globalX is not None:
            mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(globalX, self.mapToGlobal(event.y()))))
        elif globalY is not None:
            mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(self.mapToGlobal(event.x()), globalY)))
        else:
            mousePos = self.mapToScene(event.pos())


        # Initialise drag tracking for squares already created.
        self.dragging = False
        # Check leftbutton click:
        if event.button() == QtCore.Qt.LeftButton:
            try:
                # Check if click inside previously defined rectangle.
                if self.rect_item.mapRectToScene(self.rect_item.boundingRect()).contains(mousePos):
                    self.dragging = True
                else:
                    self.dragging = False
            except AttributeError:
                self.dragging = False
                self.pressLoc = mousePos

            # Track mouse movement for drag / rectangle creation.
            self.setMouseTracking(True)

            # Process start locations for dragging / rectangle creation
            if self.dragging:
                self.dragLoc = mousePos
                print("Dragged from " + str(self.dragLoc))
            else:
                # New event, remove previous rect:
                try:
                    self.scene.removeItem(self.rect_item)
                except AttributeError:
                    pass
                self.pressLoc = mousePos
                self.rect_item = QtWidgets.QGraphicsRectItem(QtCore.QRectF(self.pressLoc.x(), self.pressLoc.y(), 0, 0))
                self.scene.addItem(self.rect_item)
                print("Pressed at " + str(self.pressLoc))

        # Process right button click:
        elif event.button() == QtCore.Qt.RightButton:
            # Remove rectangle, reset drag.
            try:
                self.scene.removeItem(self.rect_item)
                self.dragging = False
                self.rectangleCleared.emit(self)
            except AttributeError:
                pass
        super(QtWidgets.QGraphicsView, self).mousePressEvent(event)

    def mouseReleaseEvent(self, event):
        if event.button() == QtCore.Qt.LeftButton:
            sceneRect = self.scene.sceneRect()

            # When pressed, snap to area within scene.
            globalX, globalY = self.keepMouseInBounds(event)
            if globalX is not None and globalY is not None:
                mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(globalX, globalY)))
            elif globalX is not None:
                mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(globalX, self.mapToGlobal(event.y()))))
            elif globalY is not None:
                mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(self.mapToGlobal(event.x()), globalY)))
            else:
                mousePos = self.mapToScene(event.pos())

            if self.dragging:
                disp = mousePos - self.dragLoc
                self.pressLoc += disp
                self.releaseLoc += disp
                self.rect_item.setRect(QtCore.QRectF(self.pressLoc, self.releaseLoc))
                print("Draggged to " + str(mousePos))
            else:
                self.releaseLoc = mousePos
                # Check if same coordinate as press:
                if self.releaseLoc == self.pressLoc:
                    try:
                        self.scene.removeItem(self.rect_item)
                    except AttributeError:
                        pass
                    self.rectangleCleared.emit(self)
                else:
                    self.rect_item.setRect(QtCore.QRectF(self.pressLoc,self.releaseLoc))
                    print("Released at " + str(self.releaseLoc))
            self.rectangleDefined.emit(self)
            self.setMouseTracking(False) #Stops moues tracking for 'mouseMoveEvent'
            self.dragging = False
        super(QtWidgets.QGraphicsView, self).mouseReleaseEvent(event)

    def mouseMoveEvent(self, event):
        # Record mouse position.
        if self.hasMouseTracking():
            # Record mouse position.
            sceneRect = self.scene.sceneRect()

            # When pressed, snap to area within scene.
            globalX, globalY = self.keepMouseInBounds(event)
            if globalX is not None and globalY is not None:
                mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(globalX, globalY)))
            elif globalX is not None:
                mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(globalX, self.mapToGlobal(event).y())))
            elif globalY is not None:
                mousePos = self.mapToScene(self.mapFromGlobal(QtCore.QPoint(self.mapToGlobal(event).x(), globalY)))
            else:
                mousePos = self.mapToScene(event.pos())

            # Use try to catch dragging not defined as attribute.
            try:
                if self.dragging:
                    # Calculate dragging displacement
                    disp = mousePos - self.dragLoc
                    # Update rectangle item.
                    self.rect_item.setRect(QtCore.QRectF(self.pressLoc + disp, self.releaseLoc + disp))
                    # print("Translated " + str(disp))
                else:
                    # Calculate new rectangle geometry:
                    self.rect_item.setRect(QtCore.QRectF(self.pressLoc,mousePos))

            except AttributeError:
                self.dragging = False
                self.setMouseTracking(False) #Stops moues tracking for 'mouseMoveEvent'
        super(QtWidgets.QGraphicsView, self).mouseMoveEvent(event)

    def keepMouseInBounds(self, event):
        eventPos = self.mapToScene(event.pos())
        sceneRect = self.scene.sceneRect()
        # Keep mouse position within scene. Update global_ variables, if out of bounds, with new position.
        globalX = None #Track changes
        if eventPos.x() < sceneRect.left():
            sceneCorner = sceneRect.topLeft()
            viewCorner = self.mapFromScene(sceneCorner)
            globalX = self.mapToGlobal(viewCorner).x()
            QtGui.QCursor.setPos(globalX, event.globalY())
        elif eventPos.x() > sceneRect.right():
            sceneCorner = sceneRect.topRight()
            viewCorner = self.mapFromScene(sceneCorner)
            globalX = self.mapToGlobal(viewCorner).x()
            QtGui.QCursor.setPos(globalX, event.globalY())

        globalY = None #Track changes
        if eventPos.y() > sceneRect.bottom():
            sceneCorner = sceneRect.bottomRight()
            viewCorner = self.mapFromScene(sceneCorner)
            globalY = self.mapToGlobal(viewCorner).y()
            if globalX is not None:
                QtGui.QCursor.setPos(globalX, globalY)
            else:
                QtGui.QCursor.setPos(event.globalX(), globalY)
        elif eventPos.y() < sceneRect.top():
            sceneCorner = sceneRect.topRight()
            viewCorner = self.mapFromScene(sceneCorner)
            globalY = self.mapToGlobal(viewCorner).y()
            if globalX is not None:
                QtGui.QCursor.setPos(globalX, globalY)
            else:
                QtGui.QCursor.setPos(event.globalX(), globalY)
        return globalX, globalY

    def getRectCoords(self):
        try:
            return self.rect_item.mapRectToScene(self.rect_item.boundingRect())
        except AttributeError:
            return None

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

        print("data " + str(contrast_data))
        vals = np.reshape(contrast_data,(contrast_data.shape[0]*contrast_data.shape[1],1))
        try:
            range = np.ptp(vals)
            print("range " + str(range))
            desiredBinsPerWidth = 20
            width = 0.1
            totalBins = int(np.floor(range/width * desiredBinsPerWidth))
            # totalBins = 256
            print(totalBins)

            cf = self.axes.hist(vals, bins=totalBins)

            #Hide pixel coordinates of image.
            self.axes.get_yaxis().set_ticks([])
            self.draw()
        except ValueError:
            self.axes.set_visible(False)
