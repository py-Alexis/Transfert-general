# This Python file uses the following encoding: utf-8
import os, glob, shutil
import time
from stat import S_IREAD, S_IRGRP, S_IROTH  # lecture seul
from stat import S_IWUSR  # enlever la lecture seul
import random
import json

from PySide2.QtCore import QObject, Slot, Signal, QThread
from api import convert_size, get_dir_size, replace_brackets
import sys

class Transfer2(QObject):
    finished = Signal()
    # percent = Signal(int)
    # cancel = Signal()

    def __init__(self):
        super().__init__()

        # read the settings.json to see the read only policy
        self.read_only = False

    def start_transfer(self, name):
        print(name)
        for i in range(5):
            print("here")
            time.sleep(2)
        self.finished.emit()
        # get path of folders

        # call the copy
        pass

    def copy(self, from_path, to_path):
        """
        for each element
            if it's a folder I look if it already exist
                if yes:
                    we start again the copy in that folder
                if no:
                    we copy the entire folder
            if it's a file I look if it already exist
                if yes I check the modification date
                    we copy if the new one is more recent
                if no:
                    we copy the file
        """

        list_to_basename = os.listdir(to_path)

        # scan the folder to get the list of files
        for contenu in glob.glob(replace_brackets(f"{from_path}/*")):
            new_path = f"{to_path}/{os.path.basename(contenu)}"

            if os.path.isdir(contenu):
                if os.path.basename(contenu) in list_to_basename:
                    # if the folder already exist, we start again in this folder

                    self.copy(contenu, new_path)

                else:
                    # if the folder doesn't exist, we copy the folder

                    shutil.copytree(contenu, new_path)
                    self.set_read_only(new_path)

            else:
                if os.path.basename(contenu) in list_to_basename:
                    # if the file already exist, we check if the new file is more recent

                    fichier_a_copier = os.path.getmtime(contenu)
                    fichier_deja_copier = os.path.getmtime(new_path)

                    if fichier_a_copier > fichier_deja_copier:
                        # if the new file is more recent, we delete the old file and copy the new one

                        os.chmod(new_path, S_IWUSR | S_IREAD)  # remove the read only
                        os.remove(new_path)  # remove the old file
                        shutil.copyfile(contenu, new_path)  # copy the new file
                        self.set_read_only(new_path)

                        # when we copy the file the modification date is updated, so we set it to what it was before
                        os.utime(new_path, (os.path.getatime(contenu), os.path.getmtime(contenu)))

                else:
                    # if the file doesn't exist, we copy it (same process as before)

                    shutil.copyfile(contenu, new_path)
                    self.set_read_only(new_path)
                    os.utime(new_path, (os.path.getatime(contenu), os.path.getmtime(contenu)))

    def set_read_only(self, path):
        """
            set the read only if needed (user set it in the settings)
        """
        if self.read_only:
            os.chmod(path, S_IREAD | S_IRGRP | S_IROTH)
        return


class Transfer(QObject):
    finished = Signal()
    finished_name = Signal(str)
    percent = Signal("QVariant")

    def __init__(self, names, folders, size):
        super().__init__()
        self.names = names
        self.folders = folders
        self.total_size_to_copy = size
        self.total_size_copy = 0
        self.name_size_copy = 0
        self.read_only = False

    def start_transfer(self):
        #     self.change_theme(get_active_them())
        #     self.send_theme_list()
        #     self.send_settings()
        #     self.get_folders()

        # copy folder  to D:\resource\save\cle_usb - Copie2
        print(self.names)
        for i in self.names:
            print(i)
            try:
                self.name_size_copy = 0
                self.copy(self.folders[i]["from"], self.folders[i]["to"], i)
                print("finished1")
            except Exception as e:
                (type, value, traceback) = sys.exc_info()
                print("=================================================")
                print(sys.excepthook(type, value, traceback))
                print(type, value, traceback)
            else:
                # add last copy date to path.json
                with open("settings/paths.json", "r", encoding="utf-8") as f:
                    data = json.load(f)
                data[i]["last_copy"] = time.time()
                with open("settings/paths.json", "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=4)
            # self.percent.emit([i, y, "100Mo"])
            print("finished2")
            self.finished_name.emit(i)

        print("finished3")
        self.finished.emit()

    def copy(self, from_path, to_path, name):
        """
        for each element
            if it's a folder I look if it already exist
                if yes:
                    we start again the copy in that folder
                if no:
                    we copy the entire folder
            if it's a file I look if it already exist
                if yes I check the modification date
                    we copy if the new one is more recent
                if no:
                    we copy the file
        """

        list_to_basename = os.listdir(to_path)

        # scan the folder to get the list of files
        for contenu in glob.glob(replace_brackets(f"{from_path}/*")):
            new_path = f"{to_path}/{os.path.basename(contenu)}"

            if os.path.isdir(contenu):
                if os.path.basename(contenu) in list_to_basename:
                    # if the folder already exist, we start again in this folder

                    self.copy(contenu, new_path, name)

                else:
                    # if the folder doesn't exist, we copy the folder

                    print(f"-------- copytree({contenu}, {new_path})")
                    shutil.copytree(contenu, new_path)
                    self.set_read_only(new_path)

                    self.name_size_copy += get_dir_size(new_path)
                    self.total_size_copy += get_dir_size(new_path)
                    self.percent.emit([name, int(self.name_size_copy/self.folders[name]["raw_size_to_copy"]*100), convert_size(self.name_size_copy)])
                    self.percent.emit(["Total", int(self.total_size_copy/self.total_size_to_copy*100), f"{int(self.total_size_copy/self.total_size_to_copy*100)} %"])
            else:
                if os.path.basename(contenu) in list_to_basename:
                    # if the file already exist, we check if the new file is more recent

                    fichier_a_copier = os.path.getmtime(contenu)
                    fichier_deja_copier = os.path.getmtime(new_path)

                    if fichier_a_copier > fichier_deja_copier:
                        # if the new file is more recent, we delete the old file and copy the new one

                        os.chmod(new_path, S_IWUSR | S_IREAD)  # remove the read only
                        os.remove(new_path)  # remove the old file
                        print(f"-------- copyfile({contenu}, {new_path})")
                        shutil.copyfile(contenu, new_path)  # copy the new file
                        self.set_read_only(new_path)
                        self.name_size_copy += os.path.getsize(contenu)
                        self.total_size_copy += os.path.getsize(contenu)
                        self.percent.emit([name, int(self.name_size_copy / self.folders[name]["raw_size_to_copy"] * 100),
                                           convert_size(self.name_size_copy)])
                        self.percent.emit(["Total", int(self.total_size_copy/self.total_size_to_copy*100), f"{int(self.total_size_copy/self.total_size_to_copy*100)} %"])

                        # when we copy the file the modification date is updated, so we set it to what it was before
                        os.utime(new_path, (os.path.getatime(contenu), os.path.getmtime(contenu)))

                else:
                    # if the file doesn't exist, we copy it (same process as before)

                    print(f"-------- copyfile({contenu}, {new_path})")
                    shutil.copyfile(contenu, new_path)
                    self.set_read_only(new_path)
                    os.utime(new_path, (os.path.getatime(contenu), os.path.getmtime(contenu)))
                    self.name_size_copy += os.path.getsize(contenu)
                    self.total_size_copy += os.path.getsize(contenu)
                    self.percent.emit([name, int(self.name_size_copy/self.folders[name]["raw_size_to_copy"]*100), convert_size(self.name_size_copy)])
                    self.percent.emit(["Total", int(self.total_size_copy/self.total_size_to_copy*100), f"{int(self.total_size_copy/self.total_size_to_copy*100)} %"])

    def set_read_only(self, path):
        """
            set the read only if needed (user set it in the settings)
        """
        if self.read_only:
            os.chmod(path, S_IREAD | S_IRGRP | S_IROTH)
        return
