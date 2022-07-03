# This Python file uses the following encoding: utf-8
import sys
import os
import webbrowser

from PySide2.QtCore import QObject, Slot, Signal
from PySide2.QtGui import QGuiApplication, QIcon
from PySide2.QtQml import QQmlApplicationEngine


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    @Slot()
    def open_github(self):
        webbrowser.open('https://github.com/py-Alexis/transfert-général', new=2)


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine(parent=app)

    app.setWindowIcon(QIcon("images/svg_images/icon_app_top.svg"))

    # I don't know why but without it there are errors.
    app.setOrganizationName("Alexis MORICE")
    app.setOrganizationDomain("j'ai_pas_de_site.com")
    app.setApplicationName("voca-liste")

    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
