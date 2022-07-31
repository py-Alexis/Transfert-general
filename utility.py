import os, shutil, glob
from stat import S_IREAD, S_IRGRP, S_IROTH  # lecture seul
from stat import S_IWUSR  # enlever la lecture seul
import random


def create_test_folder(from_path, to_path):
    # delete folder
    if os.path.exists(to_path):
        delete_folder(to_path)

    # copy the folder from source to destination
    shutil.copytree(from_path, to_path)

    # randomize the files in the destination folder
    randomize_folder(to_path)


def randomize_folder(path):
    """
     loop through all the files in the destination folder and randomly delete some of them
    """

    for file in glob.glob(f"{path}/*"):
        if random.randint(0, 3) == 1:
            if os.path.isfile(file):
                os.chmod(file, S_IWUSR | S_IREAD)
                os.remove(file)
            else:
                delete_folder(file)
        else:
            if os.path.isdir(file):
                randomize_folder(file)
            else:
                if random.randint(0, 5) == 1:
                    os.utime(file, (os.path.getatime(file), os.path.getmtime(file)-1))




def delete_folder(path):
    delete_all_file(path)
    shutil.rmtree(path)


def delete_all_file(path):
    for file in glob.glob(f"{path}/*"):
        if os.path.isfile(file):
            try:
                os.chmod(file, S_IWUSR | S_IREAD)
                os.remove(file)
            except:
                print(f"{file} is not readable")
        else:
            delete_all_file(file)


if __name__ == '__main__':
    create_test_folder("D:\\cours\\4eme", "D:\\backup\\4eme_backup")
    # get_problematic_files("D:\\backup\\4eme_backup")
