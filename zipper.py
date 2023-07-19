import os
import zipfile
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("-fn", dest="file_name")
parser.add_argument("-td", dest="target_directory")
parser.add_argument("-ep", dest="export_path")

args = parser.parse_args()

def zipfolder(zipname, target_dir, savepth = None):
    zipobj = zipfile.ZipFile('' if savepth == None else savepth + '/' + zipname + '.zip', 'w', zipfile.ZIP_DEFLATED)
    rootlen = len(target_dir) + 1
    for base, dirs, files in os.walk(target_dir):
        for file in files:
            fn = os.path.join(base, file)

            # print(str.split(target_dir,'\\')[-1])

            zipobj.write(fn, str.split(target_dir,'/')[-1] +'/'+ fn[rootlen:])
    
    zipobj.close()


#def get_paths():
#    contents = ''
#    with open("cfg.txt", "r") as file:
#        contents = file.read()
#    
#    return contents.split(',')

#zipname = input()
#target_dir = input()
#savepth = input()


if __name__ == '__main__':
    zipname, target_dir, savepth = args.file_name, args.target_directory, args.export_path

    print(zipname)
    print(target_dir)
    print(savepth)

    zipfolder(zipname, target_dir, savepth)