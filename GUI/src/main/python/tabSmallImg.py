from PyQt5 import QtCore, QtGui, QtWidgets
import os
from contrast_processing import *
import numpy as np
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt4agg import NavigationToolbar2QT as NavigationToolbar
import matplotlib.pyplot as plt

class tab4k(object):
    def setup4KTab(self, tabWidget, centralWidget):
        self.parent = tabWidget
        self.centralWidget = centralWidget

        self.Image4K_Tab = QtWidgets.QWidget()
        self.Image4K_Tab.setObjectName("Image4K_Tab")

        self.widget = QtWidgets.QWidget(self.Image4K_Tab)
        self.widget.setGeometry(QtCore.QRect(0, 0, 1041, 741))
        self.widget.setObjectName("widget")
        self.verticalLayout_14 = QtWidgets.QVBoxLayout(self.widget)
        self.verticalLayout_14.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_14.setObjectName("verticalLayout_14")

        # Processing GUI
        self.processing_hlayout = QtWidgets.QHBoxLayout()
        self.processing_hlayout.setSizeConstraint(QtWidgets.QLayout.SetDefaultConstraint)
        self.processing_hlayout.setObjectName("processing_hlayout")

        # Input Files:
        self.inputFile_vlayout = QtWidgets.QVBoxLayout()
        self.inputFile_vlayout.setSizeConstraint(QtWidgets.QLayout.SetDefaultConstraint)
        self.inputFile_vlayout.setSpacing(6)
        self.inputFile_vlayout.setObjectName("inputFile_vlayout")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout()
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.input_dir_hlayout = QtWidgets.QHBoxLayout()
        self.input_dir_hlayout.setObjectName("input_dir_hlayout")
        self.input_dir_select_btn = QtWidgets.QPushButton(self.widget)
        self.input_dir_select_btn.setObjectName("input_dir_select_btn")
        self.input_dir_hlayout.addWidget(self.input_dir_select_btn)
        self.input_dir_display = QtWidgets.QLineEdit(self.widget)
        self.input_dir_display.setReadOnly(True)
        self.input_dir_display.setObjectName("input_dir_display")
        self.input_dir_hlayout.addWidget(self.input_dir_display)
        self.verticalLayout_2.addLayout(self.input_dir_hlayout)
        self.file_management_hlayout = QtWidgets.QHBoxLayout()
        self.file_management_hlayout.setObjectName("file_management_hlayout")
        self.file_list_label = QtWidgets.QLabel(self.widget)
        self.file_list_label.setObjectName("file_list_label")
        self.file_management_hlayout.addWidget(self.file_list_label)
        self.file_manage_btns_hlayout = QtWidgets.QHBoxLayout()
        self.file_manage_btns_hlayout.setObjectName("file_manage_btns_hlayout")
        self.checkBox = QtWidgets.QCheckBox(self.widget)
        self.checkBox.setChecked(True)
        self.checkBox.setObjectName("checkBox")
        self.checkBox.setEnabled(False)
        self.file_manage_btns_hlayout.addWidget(self.checkBox)
        self.remove_files_btn = QtWidgets.QPushButton(self.widget)
        self.remove_files_btn.setObjectName("remove_files_btn")
        self.remove_files_btn.setEnabled(False)
        self.file_manage_btns_hlayout.addWidget(self.remove_files_btn)
        self.refresh_files_btn = QtWidgets.QPushButton(self.widget)
        self.refresh_files_btn.setObjectName("refresh_files_btn")
        self.file_manage_btns_hlayout.addWidget(self.refresh_files_btn)
        self.file_management_hlayout.addLayout(self.file_manage_btns_hlayout)
        self.verticalLayout_2.addLayout(self.file_management_hlayout)

        self.file_tableView = QtWidgets.QTableView(self.widget)
        self.file_tableView.setObjectName("file_tableView")
        self.file_tableView.setEditTriggers(QtWidgets.QTableWidget.NoEditTriggers)
        self.file_tableView.horizontalHeader().setStretchLastSection(True)
        self.file_tableView.setSelectionBehavior(QtWidgets.QTableView.SelectRows);
        self.verticalLayout_2.addWidget(self.file_tableView)

        self.file_filter_text = QtWidgets.QLineEdit(self.widget)
        self.file_filter_text.setText("")
        self.file_filter_text.setObjectName("file_filter_text")
        self.file_filter_text.setEnabled(False)
        self.verticalLayout_2.addWidget(self.file_filter_text)
        self.inputFile_vlayout.addLayout(self.verticalLayout_2)
        self.processing_hlayout.addLayout(self.inputFile_vlayout)

        # Image settings & previews
        self.image_vlayout = QtWidgets.QVBoxLayout()
        self.image_vlayout.setSpacing(6)
        self.image_vlayout.setObjectName("image_vlayout")
        self.image_settings_vlayout = QtWidgets.QVBoxLayout()
        self.image_settings_vlayout.setObjectName("image_settings_vlayout")

        # Img Load/Save Settings
        self.img_settings_title_hlayout = QtWidgets.QHBoxLayout()
        self.img_settings_title_hlayout.setObjectName("img_settings_title_hlayout")
        self.label_4 = QtWidgets.QLabel(self.widget)
        self.label_4.setObjectName("label_4")
        self.img_settings_title_hlayout.addWidget(self.label_4, 0, QtCore.Qt.AlignLeft)
        self.img_settings_save_btn = QtWidgets.QPushButton(self.widget)
        self.img_settings_save_btn.setObjectName("img_settings_save_btn")
        self.img_settings_title_hlayout.addWidget(self.img_settings_save_btn, 0, QtCore.Qt.AlignRight)
        self.img_settings_load_btn = QtWidgets.QPushButton(self.widget)
        self.img_settings_load_btn.setObjectName("img_settings_load_btn")
        self.img_settings_title_hlayout.addWidget(self.img_settings_load_btn, 0, QtCore.Qt.AlignRight)
        self.image_settings_vlayout.addLayout(self.img_settings_title_hlayout)
        self.img_settings_tabWidget = QtWidgets.QTabWidget(self.widget)
        self.img_settings_tabWidget.setObjectName("img_settings_tabWidget")

        # Img RGB Greyscale Tab
        self.rgb_tab = QtWidgets.QWidget()
        self.rgb_tab.setObjectName("rgb_tab")
        self.horizontalLayoutWidget_8 = QtWidgets.QWidget(self.rgb_tab)
        self.horizontalLayoutWidget_8.setGeometry(QtCore.QRect(0, 0, 511, 281))
        self.horizontalLayoutWidget_8.setObjectName("horizontalLayoutWidget_8")
        self.hlayout_2 = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget_8)
        self.hlayout_2.setContentsMargins(0, 0, 0, 0)
        self.hlayout_2.setObjectName("hlayout_2")
        self.hlayout_3 = QtWidgets.QHBoxLayout()
        self.hlayout_3.setObjectName("hlayout_3")
        self.vlayout = QtWidgets.QVBoxLayout()
        self.vlayout.setObjectName("vlayout")
        self.label_6 = QtWidgets.QLabel(self.horizontalLayoutWidget_8)
        self.label_6.setObjectName("label_6")
        self.vlayout.addWidget(self.label_6)
        self.grayscale_slider_r = QtWidgets.QSlider(self.horizontalLayoutWidget_8)
        self.grayscale_slider_r.setMaximum(100)
        self.grayscale_slider_r.setProperty("value", 100)
        self.grayscale_slider_r.setSliderPosition(100)
        self.grayscale_slider_r.setOrientation(QtCore.Qt.Vertical)
        self.grayscale_slider_r.setObjectName("grayscale_slider_r")
        self.vlayout.addWidget(self.grayscale_slider_r)
        self.hlayout_3.addLayout(self.vlayout)
        self.verticalLayout_9 = QtWidgets.QVBoxLayout()
        self.verticalLayout_9.setObjectName("verticalLayout_9")
        self.label_8 = QtWidgets.QLabel(self.horizontalLayoutWidget_8)
        self.label_8.setObjectName("label_8")
        self.verticalLayout_9.addWidget(self.label_8)
        self.grayscale_slider_g = QtWidgets.QSlider(self.horizontalLayoutWidget_8)
        self.grayscale_slider_g.setMaximum(100)
        self.grayscale_slider_g.setProperty("value", 100)
        self.grayscale_slider_g.setSliderPosition(100)
        self.grayscale_slider_g.setOrientation(QtCore.Qt.Vertical)
        self.grayscale_slider_g.setObjectName("grayscale_slider_g")
        self.verticalLayout_9.addWidget(self.grayscale_slider_g)
        self.hlayout_3.addLayout(self.verticalLayout_9)
        self.verticalLayout_8 = QtWidgets.QVBoxLayout()
        self.verticalLayout_8.setObjectName("verticalLayout_8")
        self.label_7 = QtWidgets.QLabel(self.horizontalLayoutWidget_8)
        self.label_7.setObjectName("label_7")
        self.verticalLayout_8.addWidget(self.label_7)
        self.grayscale_slider_b = QtWidgets.QSlider(self.horizontalLayoutWidget_8)
        self.grayscale_slider_b.setMaximum(100)
        self.grayscale_slider_b.setProperty("value", 100)
        self.grayscale_slider_b.setSliderPosition(100)
        self.grayscale_slider_b.setOrientation(QtCore.Qt.Vertical)
        self.grayscale_slider_b.setObjectName("grayscale_slider_b")
        self.verticalLayout_8.addWidget(self.grayscale_slider_b)
        self.hlayout_3.addLayout(self.verticalLayout_8)
        self.hlayout_2.addLayout(self.hlayout_3)
        self.grayscale_vlayout = QtWidgets.QVBoxLayout()
        self.grayscale_vlayout.setObjectName("grayscale_vlayout")
        self.label_9 = QtWidgets.QLabel(self.horizontalLayoutWidget_8)
        self.label_9.setObjectName("label_9")
        self.grayscale_vlayout.addWidget(self.label_9)
        self.grayscale_img_preview = QtWidgets.QGraphicsView(self.horizontalLayoutWidget_8)
        self.grayscale_img_preview.setObjectName("grayscale_img_preview")
        self.grayscale_vlayout.addWidget(self.grayscale_img_preview)
        self.hlayout_2.addLayout(self.grayscale_vlayout)
        self.img_settings_tabWidget.addTab(self.rgb_tab, "")

        # Img Backround / Contrast Tab
        self.background_tab = QtWidgets.QWidget()
        self.background_tab.setObjectName("background_tab")
        self.widget1 = QtWidgets.QWidget(self.background_tab)
        self.widget1.setGeometry(QtCore.QRect(0, 0, 521, 271))
        self.widget1.setObjectName("widget1")
        self.hlayout = QtWidgets.QHBoxLayout(self.widget1)
        self.hlayout.setContentsMargins(0, 0, 0, 0)
        self.hlayout.setObjectName("hlayout")
        self.groupBox = QtWidgets.QGroupBox(self.widget1)
        self.groupBox.setObjectName("groupBox")
        self.widget2 = QtWidgets.QWidget(self.groupBox)
        self.widget2.setGeometry(QtCore.QRect(10, 30, 140, 145))
        self.widget2.setObjectName("widget2")
        self.verticalLayout_15 = QtWidgets.QVBoxLayout(self.widget2)
        self.verticalLayout_15.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_15.setObjectName("verticalLayout_15")
        self.bkgnd_rb_mode = QtWidgets.QRadioButton(self.widget2)
        self.bkgnd_rb_mode.setObjectName("bkgnd_rb_mode")
        self.bkgnd_rb_mode.setChecked(True)
        self.verticalLayout_15.addWidget(self.bkgnd_rb_mode)
        self.bkgnd_rb_median = QtWidgets.QRadioButton(self.widget2)
        self.bkgnd_rb_median.setObjectName("bkgnd_rb_median")
        self.verticalLayout_15.addWidget(self.bkgnd_rb_median)
        self.verticalLayout_17 = QtWidgets.QVBoxLayout()
        self.verticalLayout_17.setObjectName("verticalLayout_17")
        self.bkgnd_rb_rgb = QtWidgets.QRadioButton(self.widget2)
        self.bkgnd_rb_rgb.setObjectName("bkgnd_rb_rgb")
        self.verticalLayout_17.addWidget(self.bkgnd_rb_rgb)
        self.verticalLayout_16 = QtWidgets.QVBoxLayout()
        self.verticalLayout_16.setObjectName("verticalLayout_16")
        self.horizontalLayout_16 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_16.setObjectName("horizontalLayout_16")
        self.label_14 = QtWidgets.QLabel(self.widget2)
        self.label_14.setObjectName("label_14")
        self.horizontalLayout_16.addWidget(self.label_14)

        self.rgb_value_display = QtWidgets.QLineEdit(self.widget2)
        self.rgb_value_display.setObjectName("rgb_value_display")
        self.rgb_value_display.setReadOnly(True)
        self.rgb_value_display.setEnabled(False)
        self.horizontalLayout_16.addWidget(self.rgb_value_display)

        self.verticalLayout_16.addLayout(self.horizontalLayout_16)
        self.rgb_colour_pick_btn = QtWidgets.QPushButton(self.widget2)
        self.rgb_colour_pick_btn.setObjectName("rgb_colour_pick_btn")
        self.rgb_colour_pick_btn.setEnabled(False)
        self.verticalLayout_16.addWidget(self.rgb_colour_pick_btn)
        self.verticalLayout_17.addLayout(self.verticalLayout_16)
        self.verticalLayout_15.addLayout(self.verticalLayout_17)
        self.hlayout.addWidget(self.groupBox)
        self.verticalLayout_18 = QtWidgets.QVBoxLayout()
        self.verticalLayout_18.setObjectName("verticalLayout_18")
        self.label_15 = QtWidgets.QLabel(self.widget1)
        self.label_15.setObjectName("label_15")
        self.verticalLayout_18.addWidget(self.label_15)
        # self.contrast_img_preview = QtWidgets.QGraphicsView(self.widget1)
        # self.contrast_img_preview.setObjectName("contrast_img_preview")
        self.contrast_img_preview = ContrastImagingCanvas()
        self.contrast_img_preview.setObjectName("contrast_img_preview")
        self.verticalLayout_18.addWidget(self.contrast_img_preview)
        self.hlayout.addLayout(self.verticalLayout_18)
        self.img_settings_tabWidget.addTab(self.background_tab, "")


        # Img Thresholding Tab
        self.threshold_tab = QtWidgets.QWidget()
        self.threshold_tab.setObjectName("threshold_tab")
        self.verticalLayoutWidget_12 = QtWidgets.QWidget(self.threshold_tab)
        self.verticalLayoutWidget_12.setGeometry(QtCore.QRect(0, 0, 511, 281))
        self.verticalLayoutWidget_12.setObjectName("verticalLayoutWidget_12")
        self.verticalLayout_12 = QtWidgets.QVBoxLayout(self.verticalLayoutWidget_12)
        self.verticalLayout_12.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_12.setObjectName("verticalLayout_12")
        self.horizontalLayout_12 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_12.setObjectName("horizontalLayout_12")
        self.label_11 = QtWidgets.QLabel(self.verticalLayoutWidget_12)
        self.label_11.setObjectName("label_11")
        self.horizontalLayout_12.addWidget(self.label_11)
        self.threshold_lower = QtWidgets.QLineEdit(self.verticalLayoutWidget_12)
        self.threshold_lower.setReadOnly(True)
        self.threshold_lower.setObjectName("threshold_lower")
        self.horizontalLayout_12.addWidget(self.threshold_lower)
        self.threshold_range_widget = QtWidgets.QSlider(self.verticalLayoutWidget_12)
        self.threshold_range_widget.setOrientation(QtCore.Qt.Horizontal)
        self.threshold_range_widget.setObjectName("threshold_range_widget")
        self.horizontalLayout_12.addWidget(self.threshold_range_widget)
        self.threshold_upper = QtWidgets.QLineEdit(self.verticalLayoutWidget_12)
        self.threshold_upper.setReadOnly(True)
        self.threshold_upper.setObjectName("threshold_upper")
        self.horizontalLayout_12.addWidget(self.threshold_upper)
        self.verticalLayout_12.addLayout(self.horizontalLayout_12)
        self.verticalLayout_11 = QtWidgets.QVBoxLayout()
        self.verticalLayout_11.setObjectName("verticalLayout_11")
        self.label_10 = QtWidgets.QLabel(self.verticalLayoutWidget_12)
        self.label_10.setObjectName("label_10")
        self.verticalLayout_11.addWidget(self.label_10)
        self.threshold_img_preview = QtWidgets.QGraphicsView(self.verticalLayoutWidget_12)
        self.threshold_img_preview.setObjectName("threshold_img_preview")
        self.verticalLayout_11.addWidget(self.threshold_img_preview)
        self.verticalLayout_12.addLayout(self.verticalLayout_11)
        self.img_settings_tabWidget.addTab(self.threshold_tab, "")
        self.image_settings_vlayout.addWidget(self.img_settings_tabWidget)
        self.image_vlayout.addLayout(self.image_settings_vlayout)

        # Set the Tab Index:
        self.img_settings_tabWidget.setCurrentIndex(0)

        # Input/Output Image Previews
        self.image_previews = QtWidgets.QHBoxLayout()
        self.image_previews.setObjectName("image_previews")
        self.input_img_vlayout = QtWidgets.QVBoxLayout()
        self.input_img_vlayout.setObjectName("input_img_vlayout")
        self.label_2 = QtWidgets.QLabel(self.widget)
        self.label_2.setObjectName("label_2")
        self.input_img_vlayout.addWidget(self.label_2)
        self.input_img_preview = QtWidgets.QGraphicsView(self.widget)
        self.input_img_preview.setObjectName("input_img_preview")
        self.input_img_vlayout.addWidget(self.input_img_preview)
        self.image_previews.addLayout(self.input_img_vlayout)
        self.output_img_vlayout = QtWidgets.QVBoxLayout()
        self.output_img_vlayout.setObjectName("output_img_vlayout")
        self.label_3 = QtWidgets.QLabel(self.widget)
        self.label_3.setObjectName("label_3")
        self.output_img_vlayout.addWidget(self.label_3)
        self.output_img_preview = QtWidgets.QGraphicsView(self.widget)
        self.output_img_preview.setObjectName("output_img_preview")
        self.output_img_vlayout.addWidget(self.output_img_preview)
        self.image_previews.addLayout(self.output_img_vlayout)
        self.image_vlayout.addLayout(self.image_previews)
        self.processing_hlayout.addLayout(self.image_vlayout)
        self.verticalLayout_14.addLayout(self.processing_hlayout)

        # Output File/Folder Settings
        self.output_hlayout = QtWidgets.QHBoxLayout()
        self.output_hlayout.setObjectName("output_hlayout")
        self.output_label = QtWidgets.QLabel(self.widget)
        self.output_label.setObjectName("output_label")
        self.output_hlayout.addWidget(self.output_label)
        self.output_folder_hlayout = QtWidgets.QHBoxLayout()
        self.output_folder_hlayout.setObjectName("output_folder_hlayout")
        self.output_folder_select_btn = QtWidgets.QPushButton(self.widget)
        self.output_folder_select_btn.setObjectName("output_folder_select_btn")
        self.output_folder_hlayout.addWidget(self.output_folder_select_btn)
        self.output_folder_display = QtWidgets.QLineEdit(self.widget)
        self.output_folder_display.setReadOnly(True)
        self.output_folder_display.setObjectName("output_folder_display")
        self.output_folder_hlayout.addWidget(self.output_folder_display)
        self.output_hlayout.addLayout(self.output_folder_hlayout)
        self.threshold_options_vlayout = QtWidgets.QHBoxLayout()
        self.threshold_options_vlayout.setObjectName("threshold_options_vlayout")
        self.threshold_enable = QtWidgets.QCheckBox(self.widget)
        self.threshold_enable.setChecked(True)
        self.threshold_enable.setObjectName("threshold_enable")
        self.threshold_options_vlayout.addWidget(self.threshold_enable)
        self.threshold_ifenabled_options = QtWidgets.QVBoxLayout()
        self.threshold_ifenabled_options.setObjectName("threshold_ifenabled_options")
        self.save_distribution_img = QtWidgets.QCheckBox(self.widget)
        self.save_distribution_img.setChecked(True)
        self.save_distribution_img.setObjectName("save_distribution_img")
        self.threshold_ifenabled_options.addWidget(self.save_distribution_img)
        self.save_contrast_img = QtWidgets.QCheckBox(self.widget)
        self.save_contrast_img.setChecked(True)
        self.save_contrast_img.setObjectName("save_contrast_img")
        self.threshold_ifenabled_options.addWidget(self.save_contrast_img)
        self.threshold_options_vlayout.addLayout(self.threshold_ifenabled_options)
        self.output_hlayout.addLayout(self.threshold_options_vlayout)
        self.start_process = QtWidgets.QPushButton(self.widget)
        self.start_process.setEnabled(False)
        self.start_process.setObjectName("start_process")
        self.output_hlayout.addWidget(self.start_process)
        self.verticalLayout_14.addLayout(self.output_hlayout)

        tabWidget.addTab(self.Image4K_Tab, "")

    def retranslateUi(self, tabWidget):
        _translate = QtCore.QCoreApplication.translate

        self.input_dir_select_btn.setText(_translate("MainWindow", "Open Directory..."))
        self.input_dir_display.setPlaceholderText(_translate("MainWindow", "Directory..."))
        self.file_list_label.setText(_translate("MainWindow", "File list:"))
        self.checkBox.setText(_translate("MainWindow", "Inc. Subdir\'s"))
        self.remove_files_btn.setText(_translate("MainWindow", "Remove Selected"))
        self.refresh_files_btn.setText(_translate("MainWindow", "Refresh from Dir."))
        self.file_filter_text.setPlaceholderText(_translate("MainWindow", "Filter files..."))
        self.label_4.setText(_translate("MainWindow", "Global Settings"))
        self.img_settings_save_btn.setText(_translate("MainWindow", "Save Settings"))
        self.img_settings_load_btn.setText(_translate("MainWindow", "Load Settings"))
        self.groupBox.setTitle(_translate("MainWindow", "Select Background:"))
        self.bkgnd_rb_mode.setText(_translate("MainWindow", "Mode"))
        self.bkgnd_rb_median.setText(_translate("MainWindow", "Median"))
        self.bkgnd_rb_rgb.setText(_translate("MainWindow", "Custom RGB"))
        self.label_14.setText(_translate("MainWindow", "rgba"))
        self.rgb_colour_pick_btn.setText(_translate("MainWindow", "Colour Picker"))
        self.label_15.setText(_translate("MainWindow", "Contrast Image Preview"))
        self.img_settings_tabWidget.setTabText(self.img_settings_tabWidget.indexOf(self.background_tab), _translate("MainWindow", "Background and Contrast"))
        self.label_6.setText(_translate("MainWindow", "Red"))
        self.label_8.setText(_translate("MainWindow", "Green"))
        self.label_7.setText(_translate("MainWindow", "Blue"))
        self.label_9.setText(_translate("MainWindow", "Grayscale Image:"))
        self.img_settings_tabWidget.setTabText(self.img_settings_tabWidget.indexOf(self.rgb_tab), _translate("MainWindow", "RGB to Grayscale"))
        self.label_11.setText(_translate("MainWindow", "Threshold Range"))
        self.label_10.setText(_translate("MainWindow", "Contrast Distribution"))
        self.img_settings_tabWidget.setTabText(self.img_settings_tabWidget.indexOf(self.threshold_tab), _translate("MainWindow", "Thresholding"))
        self.label_2.setText(_translate("MainWindow", "Image Input Preview"))
        self.label_3.setText(_translate("MainWindow", "Image Output Preview"))
        self.output_label.setText(_translate("MainWindow", "Output:"))
        self.output_folder_select_btn.setText(_translate("MainWindow", "Select"))
        self.output_folder_display.setPlaceholderText(_translate("MainWindow", "Output folder..."))
        self.threshold_enable.setText(_translate("MainWindow", "Thresholding Enabled"))
        self.save_distribution_img.setText(_translate("MainWindow", "Save Contrast Distribution"))
        self.save_contrast_img.setText(_translate("MainWindow", "Save Contrast Image"))
        self.start_process.setText(_translate("MainWindow", "Start Process"))
        tabWidget.setTabText(tabWidget.indexOf(self.Image4K_Tab), _translate("MainWindow", "Images (<4K)"))

    def setupConnections(self):
        self.input_dir_select_btn.clicked.connect(self.selectDir)
        self.refresh_files_btn.clicked.connect(self.refreshFromDir)
        self.file_tableView.clicked.connect(self.onFileSelect)
        self.threshold_enable.stateChanged.connect(self.changedThresholdEnable)
        self.rgb_colour_pick_btn.clicked.connect(self.getBackgroundColour)
        self.grayscale_slider_r.sliderReleased.connect(self.RGBsliderUpdate)
        self.grayscale_slider_g.sliderReleased.connect(self.RGBsliderUpdate)
        self.grayscale_slider_b.sliderReleased.connect(self.RGBsliderUpdate)
        self.bkgnd_rb_rgb.toggled.connect(self.backgroundModeChange)
        self.bkgnd_rb_median.toggled.connect(self.backgroundModeChange)
        self.bkgnd_rb_mode.toggled.connect(self.backgroundModeChange)
        # self.bkgnd_rb_mean.toggled.connect(self.backgroundModeChange)


    def getBackgroundColour(self):
        self.rgb_colour_val = QtWidgets.QColorDialog.getColor()
        self.rgb_value_display.setText(str(self.rgb_colour_val.getRgb()))
        palette = QtGui.QPalette()
        palette.setColor(QtGui.QPalette.Base, self.rgb_colour_val)
        palette.setColor(QtGui.QPalette.Text, QtCore.Qt.white)
        self.rgb_value_display.setPalette(palette)

    # def background_method_change(self):
        # if self.bkgnd_rb_rgb.isChecked():


    def changedThresholdEnable(self):
        if self.threshold_enable.isChecked():
            self.save_contrast_img.setEnabled(True)
            self.save_distribution_img.setEnabled(True)
        else:
            self.save_contrast_img.setEnabled(False)
            self.save_distribution_img.setEnabled(False)

    def selectDir(self):
        # Get user input for folder
        dir = str(QtWidgets.QFileDialog.getExistingDirectory(self.centralWidget, "Select Directory"))
        self.input_dir_display.setText(dir)
        self.locateImgs(dir)

    def refreshFromDir(self):
        txt = self.input_dir_display.text()
        if txt != "":
            self.locateImgs(txt)

    def locateImgs(self,dir):
        # Replace current filelist with new filelist:
        self.imagefile_set = QtGui.QStandardItemModel(self.file_tableView)
        # self.imagefile_set = QtCore.QStringListModel(self.file_tableView)

        # Walk path to get all image files:
        filetypes = ['png', 'jpg', 'bmp']
        for (dirpath, dirnames, filenames) in os.walk(dir):
            for file in filenames:
                if file.split(".")[-1] in filetypes:
                    d = QtGui.QStandardItem(dirpath)
                    f = QtGui.QStandardItem(file)
                    self.imagefile_set.appendRow([d,f])

        self.imagefile_set.setHorizontalHeaderLabels(['Directory','Filename'])
        self.file_tableView.setModel(self.imagefile_set)

    def backgroundModeChange(self):
        if self.bkgnd_rb_rgb.isChecked():
            # self.verticalLayout_16.setEnabled(False)
            self.rgb_colour_pick_btn.setEnabled(True)
            self.rgb_value_display.setEnabled(True)
        else:
            # self.verticalLayout_16.setEnabled(True)
            self.rgb_colour_pick_btn.setEnabled(False)
            self.rgb_value_display.setEnabled(False)
        # Because of toggle, generate new contrast preview image.
        self.generateContrastImage()

    def onFileSelect(self):
        currentSelection = self.file_tableView.selectionModel()
        if currentSelection.hasSelection():
            lastSelectedRowIndex = currentSelection.selectedRows()[-1].row()
            directory = self.imagefile_set.item(lastSelectedRowIndex,0).text()
            filename = self.imagefile_set.item(lastSelectedRowIndex,1).text()
            filepath = os.path.join(directory, filename)
            # Load Image
            self.loadInputImgPreview(filepath)
            # Create Grayscale Preview
            cr = self.grayscale_slider_r.value()
            cg = self.grayscale_slider_g.value()
            cb = self.grayscale_slider_b.value()
            self.grayImgData = create_Grayscale(filepath, cr, cg, cb)
            # Draw Grayscale Preview
            grayImg = Image.fromarray( np.asarray( np.clip(self.grayImgData,0,255), dtype="uint8"), "L" )
            grayImg = ImageQt.ImageQt(grayImg)
            self.drawGrayscaleImagePreview(grayImg)
            # Generate
            self.generateContrastImage()

        else:
            # Clear Canvas
            self.clearInputImgPreview()
            self.clearGrayscaleImgPreview()
            self.clearContrastImgPreview()


    def generateContrastImage(self):
        # Get background selection:
        if self.bkgnd_rb_mode.isChecked():
            backgroundValue = background_Mode(self.grayImgData)
        elif self.bkgnd_rb_median.isChecked():
            backgroundValue = background_Median(self.grayImgData)
        # elif self.bkgnd_rb_mean.isChecked():
            # background_mean(self.grayImgData)
        elif self.bkgnd_rb_rgb.isChecked():
            backgroundValue = self.rgb_colour_val.getRgb()
            # Convert to gray
            cr = self.grayscale_slider_r.value()
            cg = self.grayscale_slider_g.value()
            cb = self.grayscale_slider_b.value()
            backgroundValue = backgroundValue[0]*cr + backgroundValue[1]*cg + backgroundValue[2]*cb / (cr + cg + cb)

        # Create Contrast Image Preview
        self.contrastImgData = create_Contrast(self.grayImgData, backgroundValue)
        # Draw Contrast Image Preview
                        # self.contrast_img_preview_figure = create_Contrast_Matplotlib(self.contrastImgData)
                        # self.contrast_img_preview = FigureCanvas(fig)
                        # self.contrast_img_preview.setSizePolicy(QtWidgets.QSizePolicy.Expanding,QtWidgets.QSizePolicy.Expanding)
                        # self.contrast_img_preview.updateGeometry()
                        # self.contrast_img_preview.draw()
                        # size = canvas.size()
                        # width, height = size.width(), size.height()
                        # self.contrast_img_preview = canvas
        self.contrast_img_preview.setContrastData(self.contrastImgData)
        # im = QtGui.QImage(canvas.buffer_rgba(), width, height, QtGui.QImage.Format_ARGB32)
        # print(im.size())
        # self.drawContrastImagePreview(im)

    def RGBsliderUpdate(self):
        # Behaviour is the same for generating a preview image.
        self.onFileSelect()

    def drawContrastImagePreview(self, QIm):
        scene = QtWidgets.QGraphicsScene()
        image = QtGui.QPixmap.fromImage(QIm)
        item = QtWidgets.QGraphicsPixmapItem(image)
        scene.addItem(item)
        self.contrast_img_preview.setScene(scene)
        self.contrast_img_preview.fitInView(scene.itemsBoundingRect(), QtCore.Qt.KeepAspectRatio)

    def clearContrastImgPreview(self):
        scene = QtWidgets.QGraphicsScene()
        self.contrast.setScene(scene)

    def clearGrayscaleImgPreview(self):
        scene = QtWidgets.QGraphicsScene()
        self.grayscale_img_preview.setScene(scene)

    def drawGrayscaleImagePreview(self, QIm):
        scene = QtWidgets.QGraphicsScene()
        image = QtGui.QPixmap.fromImage(QIm)
        item = QtWidgets.QGraphicsPixmapItem(image)
        scene.addItem(item)
        self.grayscale_img_preview.setScene(scene)
        self.grayscale_img_preview.fitInView(scene.itemsBoundingRect(), QtCore.Qt.KeepAspectRatio)

    def clearInputImgPreview(self):
        scene = QtWidgets.QGraphicsScene()
        self.input_img_preview.setScene(scene)

    # from PyQt5.QtGui import QIcon, QPixmap
    def loadInputImgPreview(self, filepath):
        scene = QtWidgets.QGraphicsScene()
        # image = QtGui.QImage(directory + "/" + filename) //Need to chage to QImage later for manipulation.
        image = QtGui.QPixmap(filepath)
        item = QtWidgets.QGraphicsPixmapItem(image)
        scene.addItem(item)

        self.input_img_preview.setScene(scene)
        self.input_img_preview.fitInView(scene.itemsBoundingRect(), QtCore.Qt.KeepAspectRatio)

        # Smooth zooming:
        # https://wiki.qt.io/Smooth_Zoom_In_QGraphicsView
