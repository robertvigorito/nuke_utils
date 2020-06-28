import nuke


def enable_raw():
    """
    Enabling the raw checkbox to ensure raw process when working
    on client plates.
    """
    node = nuke.thisNode()
    if not node.knob("raw"):
        return False

    node.knob("raw").setValue(True)
    return True
