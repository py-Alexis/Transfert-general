# This Python file uses the following encoding: utf-8
import sys
import os
import webbrowser
import json
import time
import random

from PySide2.QtCore import QObject, Slot, Signal, QThread
from PySide2.QtGui import QGuiApplication, QIcon
from PySide2.QtQml import QQmlApplicationEngine

from api import api_get_list_folders


def get_active_them():
    """
        get the active theme in settings.json
    """
    with open("settings/settings.json", "r") as f:
        settings = json.load(f)
        return settings["Active Theme"]


class LoadingSequence(QObject):
    finished = Signal()
    percent = Signal(int)
    text = Signal(str)

    def __init__(self, main_window):
        super().__init__()
        self.main_window = main_window

    def loading(self):
        #     self.change_theme(get_active_them())
        #     self.send_theme_list()
        #     self.send_settings()
        #     self.get_folders()

        self.text.emit('Starting...')

        print(self.main_window)
        self.main_window.get_folders()
        time.sleep(random.randrange(1, 2))
        # self.percent.emit(6)
        # time.sleep(random.randrange(1, 2))
        # self.percent.emit(16)
        # time.sleep(random.randrange(1, 2))
        # self.percent.emit(39)
        #
        # self.text.emit('Loading Theme...')
        self.main_window.change_theme(get_active_them())
        # print("here")
        self.main_window.send_theme_list()
        # print("no here")
        # time.sleep(random.randrange(1, 2))
        #
        # self.percent.emit(83)
        # self.text.emit('Loading Settings...')
        # self.main_window.send_settings()
        # time.sleep(random.randrange(1, 2))
        self.percent.emit(100)

        self.text.emit('...')

        time.sleep(1)

        self.finished.emit()


class SlashScreen(QObject):
    def __init__(self, main_window):
        QObject.__init__(self)
        self.main_window = main_window

    def init(self):
        self.thread = QThread(self)
        self.starting_sequence = LoadingSequence(self.main_window)
        self.starting_sequence.moveToThread(self.thread)
        self.thread.started.connect(self.starting_sequence.loading)
        self.starting_sequence.finished.connect(self.finish)
        self.starting_sequence.percent.connect(self.update_percent)
        self.starting_sequence.text.connect(self.update_text)
        self.thread.start()

    send_finished_signal = Signal()

    def finish(self):
        self.thread.quit()
        self.send_finished_signal.emit()

    send_percent_signal = Signal(int)

    def update_percent(self, percent):
        self.send_percent_signal.emit(percent)

    send_text_signal = Signal(str)

    def update_text(self, text):
        self.send_text_signal.emit(text)

    send_theme_info_signal = Signal("QVariant")

    @Slot(str)
    def change_theme(self, theme_name):
        """
        Send the name of the theme.
        :param theme_name:
        :return: None
        """

        with open("settings/Themes/" + theme_name + ".json", "r") as f:
            theme_dict = eval(f.read())
        self.send_theme_info_signal.emit(theme_dict)


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    # def startup(self):
    #     self.change_theme(get_active_them())
    #     self.send_theme_list()
    #     self.send_settings()
    #     self.get_folders()

    send_folders = Signal("QVariant")
    send_size = Signal(str)
    @Slot()
    def get_folders(self):
        folders, size = api_get_list_folders()
        for folder in folders:
            folders[folder]["from"] = folders[folder]["from"].replace("\\", "/")
            folders[folder]["to"] = folders[folder]["to"].replace("\\", "/")

        self.send_folders.emit(folders)
        print(size)
        self.send_size.emit(size + " ")

    @Slot()
    def open_github(self):
        webbrowser.open('https://github.com/py-Alexis/Transfert-general', new=2)

    send_show_window_signal = Signal()
    @Slot()
    def show_main_window(self):
        time.sleep(1)
        self.send_show_window_signal.emit()

    send_theme_info_signal = Signal("QVariant", str)
    @Slot(str)
    def change_theme(self, theme_name):
        """
        Send the colors of the theme.
        And change the active theme in settings.json
        """

        # get the colors of the theme
        with open("Settings/Themes/" + theme_name + ".json", "r") as f:
            theme_dict = eval(f.read())
        self.send_theme_info_signal.emit(theme_dict, theme_name)  # send the colors of the theme

        # change the active theme in settings.json
        with open("Settings/settings.json", "r") as f:
            settings = json.load(f)
            settings["Active Theme"] = theme_name
        with open("Settings/settings.json", "w") as f:
            json.dump(settings, f, indent=4)

    send_theme_list_signal = Signal("QVariant")
    def send_theme_list(self):
        """
        Send the list of available themes.
        """
        liste = os.listdir("Settings/Themes")

        # remove .json extension
        liste = [x[:-5] for x in liste]

        self.send_theme_list_signal.emit(liste)

    send_settings_signal = Signal(bool)
    def send_settings(self):
        """
        Send the settings.
        ["compagny_mode"]
        """
        with open("Settings/settings.json", "r") as f:
            settings = json.load(f)
        self.send_settings_signal.emit(settings["company_mode"])

    @Slot(str, str, str, bool)
    def create_path(self, name, from_path, to_path, modify):
        """
        Create a path in the paths.json file.
        """

        with open("settings/paths.json", "r", encoding="utf-8") as f:
            paths = json.load(f)

        if name in paths and modify is False:
            return False

        paths[name] = {"from": from_path.replace('/', '\\'), "to": to_path.replace('/', '\\')}

        with open("settings/paths.json", "w", encoding="utf-8") as f:
            json.dump(paths, f, indent=4)

    @Slot(str)
    def delete_path(self, name):
        """
        Delete a path in the paths.json file.
        """

        with open("settings/paths.json", "r", encoding="utf-8") as f:
            paths = json.load(f)

        if name not in paths:
            return False

        del paths[name]

        with open("settings/paths.json", "w", encoding="utf-8") as f:
            json.dump(paths, f, indent=4)

    send_create_bars_signal = Signal("QVariant")
    @Slot("QVariant")
    def create_bars(self, dict):
        self.send_create_bars_signal.emit(dict)

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine(parent=app)

    app.setWindowIcon(QIcon("images/svg_images/icon_app_top.svg"))

    # I don't know why but without it there are errors.
    app.setOrganizationName("Alexis MORICE")
    app.setOrganizationDomain("j'ai_pas_de_site.com")
    app.setApplicationName("voca-liste")

    # main window
    main = MainWindow()
    engine.rootContext().setContextProperty("main", main)
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    # Loading screen
    splash = SlashScreen(main)
    engine.rootContext().setContextProperty("backend", splash)
    engine.load(os.path.join(os.path.dirname(__file__), "qml/pages/Splash_screen.qml"))
    splash.change_theme(get_active_them())

    splash.init()
    # main.startup()

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
