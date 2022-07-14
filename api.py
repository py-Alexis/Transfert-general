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
            folders[folder]["size"] = convert_size(get_dir_size(folders[folder]["from"]))
        else:
            folders[folder]["from_valid"] = False

            # add size key
            folders[folder]["size"] = 0

        if os.path.exists(folders[folder]["to"]):
            folders[folder]["to_valid"] = True
        else:
            folders[folder]["to_valid"] = False



    # add size to copy key
    for folder in folders:
        folders[folder]["size_to_copy"] = "soon..."

    # add a last copy key if it has never been copied
    for folder in folders:
        if not "last_copy" in folders[folder]:
            folders[folder]["last_copy"] = "Jamais"

    return folders


if __name__ == "__main__":
    for folder in api_get_list_folders():
        print(folder, api_get_list_folders()[folder])