"""
Parse the AC-34 XML filetypes.
"""

import sys
from xml.etree import ElementTree

def print_vertex(vtx):
    print "Vertex,%d,%f,%f" % (int(vtx.get('Seq', -1)), 
                               float(vtx.get('Y', -99999)), 
                               float(vtx.get('X', -99999)))

def parse_boat_xml(xml_tree):
    for boatshape in xml_tree.findall('BoatShapes/BoatShape'):
        print "Boat shape,%d" % int(boatshape.get('ShapeID', -1))
        for vtx in boatshape.findall('Vertices/Vtx'):
            print_vertex(vtx)
        print "Catamaran"
        for vtx in boatshape.findall('Catamaran/Vtx'):
            print_vertex(vtx)
        print "Bowsprit"
        for vtx in boatshape.findall('Bowsprit/Vtx'):
            print_vertex(vtx)
        print "Trampoline"
        for vtx in boatshape.findall('Trampoline/Vtx'):
            print_vertex(vtx)


def main():
    tree = ElementTree.parse(sys.stdin)
    parse_boat_xml(tree.getroot())


if __name__ == '__main__':
    main()
