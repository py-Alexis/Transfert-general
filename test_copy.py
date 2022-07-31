import api
import os
import unittest


class TestBackup(unittest.TestCase):
    from_path = "D:\\cours\\4eme"
    to_path = "D:\\backup\\4eme_backup"

    def test_size(self):
        self.assertEqual(api.get_dir_size(self.from_path), api.get_dir_size(self.to_path))

    def test_files(self):
        self.assertEqual(self.list_files(self.from_path)[1:], self.list_files(self.to_path)[1:])

    def test_modification_date(self):
        self.assertEqual(self.list_modification_date(self.from_path), self.list_modification_date(self.to_path))

    def list_files(self, startpath):
        liste = []
        for root, dirs, files in os.walk(startpath):
            level = root.replace(startpath, '').count(os.sep)
            indent = ' ' * 4 * (level)
            liste.append('{}{}/'.format(indent, os.path.basename(root)))
            subindent = ' ' * 4 * (level + 1)
            for f in files:
                liste.append('{}{}'.format(subindent, f))

        return liste

    def list_modification_date(self, startpath):
        liste = []
        for root, dirs, files in os.walk(startpath):
            for file in files:
                liste.append(os.path.getmtime(f"{root}\\{file}"))
        return liste


if __name__ == '__main__':
    unittest.main()