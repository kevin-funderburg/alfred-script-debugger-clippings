#!/usr/bin/python
# encoding: utf-8

from __future__ import unicode_literals

import os
import sys
from workflow import Workflow3

wf = None
log = None

nothing_found_error_text = 'Nothing found'


def main(wf):

    clipFolders = ["~/Dropbox/Library/Application Support/Script Debugger 7/Clippings", "/Applications/Script Debugger.app/Contents/ApplicationSupport/Clippings"]

    log.debug(os.getenv('thePath'))
    try:
        thePath = os.getenv('thePath')
    except Exception:
        thePath = None
        pass

    if thePath is None:
        theFolder = clipFolders
    else:
        theFolder = [thePath]

    x = 0
    while x < len(theFolder):
        thePath = None

        files = os.listdir(os.path.expanduser(theFolder[x]))

        for file in files:

            if ".DS" not in file:
                if ".txt" not in file:

                    if thePath is None:
                        _arg = theFolder[x] + "/" + file
                    else:
                        _arg = thePath + "/" + file

                    itm = wf.add_item(title=file,
                                subtitle="view clippings for " + file,
                                arg= _arg,
                                autocomplete=file,
                                valid=True,
                                icon=theFolder[x] + "/" + file,
                                icontype="fileicon",
                                quicklookurl=file)

                    itm.setvar('isLeaf', 'false')
                    itm.setvar('thePath', theFolder[x] + "/" + file)

                    itm.add_modifier('cmd', subtitle="open the " + file + " folder in Finder", arg=theFolder[x] + "/" + file, valid=True)
                    itm.add_modifier('alt', subtitle="open clippings folder", arg=theFolder[0], valid=True)

                else:
                    _arg = file

                    if thePath is None:
                        thePath = os.path.expanduser(theFolder[x])

                    itm = wf.add_item(title=file,
                                     subtitle="insert clipping",
                                     arg=_arg,
                                     autocomplete=file,
                                     valid=True,
                                     icon=file,
                                     icontype="fileicon",
                                     quicklookurl=file)

                    itm.setvar('isLeaf', 'true')
                    itm.setvar('thePath', thePath + "/" + file)

                    itm.add_modifier('cmd', subtitle="edit clipping in default text editor", arg=thePath + "/" + file, valid=True)
                    itm.add_modifier('alt', subtitle="open clippings folder", arg=theFolder[0], valid=True)
        x += 1

    return wf.send_feedback()

if __name__ == "__main__":
    wf = Workflow3()
    log = wf.logger
    sys.exit(wf.run(main))
