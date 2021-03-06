import os
import json


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
            # todo: actually check file by file for the size to backup because some file might be in the to folder but not in the from folder
            size_to_copy = folders[folder]["size"] - get_dir_size(folders[folder]["to"])
            total_size_to_copy += size_to_copy
            folders[folder]["size_to_copy"] = convert_size(size_to_copy)
        else:
            folders[folder]["size_to_copy"] = "-"

        if folders[folder]["from_valid"]:
            folders[folder]["size"] = convert_size(folders[folder]["size"])

    # add a last copy key if it has never been copied
    for folder in folders:
        if "last_copy" not in folders[folder]:
            folders[folder]["last_copy"] = "Jamais"

    return folders, convert_size(total_size_to_copy)


if __name__ == "__main__":
    # for folder in api_get_list_folders():
    #     print(folder, api_get_list_folders()[folder])
    folders, size = api_get_list_folders()
    print(size)