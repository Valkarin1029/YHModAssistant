import os
import zipfile

def zipfolder(zipname, target_dir, savepth = None):
    zipobj = zipfile.ZipFile('' if savepth == None else savepth + '/' + zipname + '.zip', 'w', zipfile.ZIP_DEFLATED)
    rootlen = len(target_dir) + 1
    for base, dirs, files in os.walk(target_dir):
        for file in files:
            fn = os.path.join(base, file)

            # print(str.split(target_dir,'\\')[-1])

            zipobj.write(fn, str.split(target_dir,'/')[-1] +'/'+ fn[rootlen:])
    
    zipobj.close()


def get_paths():
    contents = ''
    with open("cfg.txt", "r") as file:
        contents = file.read()
    
    return contents.split(',')

#zipname = input()
#target_dir = input()
#savepth = input()


if __name__ == '__main__':
    zipname, target_dir, savepth = get_paths()

    print(zipname)
    print(target_dir)
    print(savepth)

    zipfolder(zipname, target_dir, savepth)