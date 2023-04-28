import argparse

parser = argparse.ArgumentParser()

parser.add_argument("-fn", dest="file_name")
parser.add_argument("-td", dest="target_folder")
parser.add_argument("-ep", dest="export_path")

args = parser.parse_args()

print(args.file_name)
print(args.target_folder)
print(args.export_path)