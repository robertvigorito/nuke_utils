import nuke


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






