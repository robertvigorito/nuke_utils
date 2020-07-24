import nuke
import os
import re


def set_localization(flag):
    """
    Set the localization policy of the nodes selected or all nodes
    in the script to the flag provided.

    Args:
        flag(int):      Localization Policy Value

    Returns:
        True if successful, False otherwise
    """
    for node in nuke.selectedNodes("Read") or nuke.allNodes("Read"):
        node["localizationPolicy"].setValue(flag)
        # Ensure to reload after the option has been set
        node["updateLocalization"].execute()

    return True


def read_from_write():
    """
    Create a read node from the write node, if the path is a mov, create from user text
    else look into the directory for the frame range.

    Returns:
        (nuke.node) Read node
    """
    node = nuke.selectedNode()
    if node.Class() != "Write":
        return False

    pattern = r"^\w+.(\d+)."
    path = node["file"].getValue()

    if path.endswith('.mov') and os.path.exists(path):
        read = nuke.nodes.Read(xpos=node.xpos(), ypos=node.ypos() + 100)
        read['file'].fromUserText(path)
    else:
        try:
            frames = sorted(os.listdir(os.path.dirname(path)))
            first = re.findall(pattern=pattern, string=frames[0])[0]
            last = re.findall(pattern=pattern, string=frames[-1])[0]
        except IndexError:
            first, last = nuke.root().firstFrame(), nuke.root().lastFrame()

        read = nuke.nodes.Read(xpos=node.xpos(), ypos=node.ypos() + 100, file=path, first=first, last=last)

    return read


