import os
import json
import glob
import shutil
import datetime
import re


def get_dir_size(path='.'):
    """
    from https://note.nkmk.me/en/python-os-path-getsize/#:~:text=source%3A%20os_path_getsize.py-,Get%20the%20size%20of%20a%20directory%20with%20os.,in%20a%20directory%20(folder).
    """
    total = 0
    with os.scandir(path) as it:
        for entry in it:
            if entry.is_file():
                total += entry.stat().st_size
            elif entry.is_dir():
                total += get_dir_size(entry.path)
    return total


def get_size_diff(from_path, to_path):
    """
    return the size difference between the two paths
    """

    size_diff = 0
    list_to_basename = os.listdir(to_path)

    # scan the folder to get the list of files
    for contenu in glob.glob(replace_brackets(f"{from_path}/*")):
        print(contenu)
        new_path = f"{to_path}/{os.path.basename(contenu)}"

        if os.path.isdir(contenu):
            if os.path.basename(contenu) in list_to_basename:
                # if the folder already exist, we start again in this folder

                size_diff += get_size_diff(contenu, new_path)

            else:
                # if the folder doesn't exist, we copy the folder
                size_diff += get_dir_size(contenu)

        else:
            if os.path.basename(contenu) in list_to_basename:
                # if the file already exist, we check if the new file is more recent

                fichier_a_copier = os.path.getmtime(contenu)
                fichier_deja_copier = os.path.getmtime(new_path)

                if fichier_a_copier > fichier_deja_copier:
                    # if the new file is more recent, we delete the old file and copy the new one
                    size_diff += os.path.getsize(contenu)

            else:
                # if the file doesn't exist, we copy it (same process as before)
                size_diff += os.path.getsize(contenu)

    return size_diff


def convert_size(byte):
    """
        convert the size to something like 1Go 200Mo
    """
    if byte < 1024:
        return str(byte) + "o"
    elif byte < 1048576:
        return str(round(byte / 1024, 2)) + "Ko"
    elif byte < 1073741824:
        return str(round(byte / 1048576, 2)) + "Mo"
    elif byte < 1099511627776:
        return str(round(byte / 1073741824, 2)) + "Go"
    else:
        return str(round(byte / 1099511627776, 2)) + "To"


def api_get_list_folders():
    """
    Return the list folders to backup.
    and the size that will be backuped.
    """

    # read the paths.json file
    with open("settings/paths.json", "r", encoding="utf-8") as f:
        folders = json.load(f)

    # check if the paths are valid
    # add a key "valid" to the dict
    for folder in folders:
        if os.path.exists(folders[folder]["from"]):
            folders[folder]["from_valid"] = True

            # add size key
            folders[folder]["size"] = get_dir_size(folders[folder]["from"])
        else:
            folders[folder]["from_valid"] = False

            # add size key
            folders[folder]["size"] = "-"

        if os.path.exists(folders[folder]["to"]):
            folders[folder]["to_valid"] = True
        else:
            folders[folder]["to_valid"] = False

    total_size_to_copy = 0
    # add size to copy key
    for folder in folders:
        if folders[folder]["from_valid"] and folders[folder]["to_valid"]:
            size_to_copy = get_size_diff(folders[folder]["from"], folders[folder]["to"])
            print(size_to_copy, folders[folder]["from"], folders[folder]["to"])
            total_size_to_copy += size_to_copy
            folders[folder]["raw_size_to_copy"] = size_to_copy
            folders[folder]["size_to_copy"] = convert_size(size_to_copy)
        else:
            folders[folder]["size_to_copy"] = "-"

        if folders[folder]["from_valid"]:
            folders[folder]["raw_size"] = folders[folder]["size"]
            folders[folder]["size"] = convert_size(folders[folder]["size"])

    # add a last copy key if it has never been copied
    for folder in folders:
        if "last_copy" not in folders[folder]:
            folders[folder]["last_copy"] = "Jamais"
        else:
            folders[folder]["last_copy"] = datetime.datetime.fromtimestamp(folders[folder]["last_copy"]).strftime("%d/%m/%y %H:%M")

    return folders, convert_size(total_size_to_copy), total_size_to_copy


def replace_brackets(text):
    """Replace [...] with [[]...[]] to make path work with glob.glob"""
    return re.sub(r'\[([^\]]+)\]', r'[[]\1[]]', text)


if __name__ == "__main__":
    pass
# TODO: make a new glob.glob that include all files and folders while taking care of [