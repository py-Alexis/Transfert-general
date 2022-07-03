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

    def __init__(self):
        super().__init__()

    def loading(self):
        self.text.emit('Starting...')

        time.sleep(random.randrange(1, 2))
        self.percent.emit(6)
        time.sleep(random.randrange(1, 2))
        self.percent.emit(16)
        time.sleep(random.randrange(1, 2))
        self.percent.emit(39)

        self.text.emit('Loading Theme...')
        time.sleep(random.randrange(1, 2))
        self.percent.emit(83)
        self.text.emit('Loading Settings...')
        time.sleep(random.randrange(1, 2))
        self.percent.emit(100)

        self.text.emit('...')

        time.sleep(1)

        self.finished.emit()


class SlashScreen(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.thread = QThread(self)
        self.starting_sequence = LoadingSequence()
        self.starting_sequence.moveToThread(self.thread)
        self.thread.started.connect(self.starting_sequence.loading)
        self.starting_sequence.finished.connect(self.finish)
        self.starting_sequence.percent.connect(self.update_percent)
        self.starting_sequence.text.connect(self.update_text)
        self.thread.start()

    send_finished_signal = Signal()

    def finish(self):
        print("finished")
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

    @Slot()
    def open_github(self):
        webbrowser.open('https://github.com/py-Alexis/Transfert-general', new=2)


    send_show_window_signal = Signal()
    @Slot()
    def show_main_window(self):
        print("wait")
        time.sleep(1)
        print("wait")
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
        print(theme_name)
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


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine(parent=app)

    app.setWindowIcon(QIcon("images/svg_images/icon_app_top.svg"))

    # I don't know why but without it there are errors.
    app.setOrganizationName("Alexis MORICE")
    app.setOrganizationDomain("j'ai_pas_de_site.com")
    app.setApplicationName("voca-liste")

    # Loading screen
    splash = SlashScreen()
    engine.rootContext().setContextProperty("backend", splash)
    engine.load(os.path.join(os.path.dirname(__file__), "qml/pages/Splash_screen.qml"))
    splash.change_theme(get_active_them())

    # main window
    main = MainWindow()
    engine.rootContext().setContextProperty("main", main)
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))
    main.change_theme(get_active_them())
    main.send_theme_list()

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
