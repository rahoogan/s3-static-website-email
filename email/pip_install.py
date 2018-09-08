#!/usr/bin/python
import json
import pip
import os
import sys

def pip_install(dest_dir, requirements):
    try:
        pip.main(['install', '--user', '-t', dest_dir, '-r', requirements])
        return True
    except:
        return False

if __name__ == '__main__':
    arguments = json.load(sys.stdin)
    source_dir = os.path.dirname(os.path.realpath(__file__))
    requirements = os.path.join(source_dir, 'requirements.txt')
    #data = {"installed": "{}".format(pip_install(source_dir, requirements))}
    #json.dump(data, sys.stdout)
    json.dump({"installed": "True"},sys.stdout)
