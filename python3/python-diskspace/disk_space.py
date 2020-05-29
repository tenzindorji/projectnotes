#!/usr/bin/env python

import os
from collections import namedtuple

s = os.statvfs("/")
diskSpacePercent =  s.f_frsize * s.f_blocks
print diskSpacePercent

diskSpacePercent = (s.f_frsize * s.f_bfree) / 1024
print diskSpacePercent



DiskUsage = namedtuple('DiskUsage', 'total used free')

def disk_usage(path):
    """Return disk usage statistics about the given path.

    Will return the namedtuple with attributes: 'total', 'used' and 'free',
    which are the amount of total, used and free space, in bytes.
    """
    st = os.statvfs(path)
    free = st.f_bavail * st.f_frsize
    total = st.f_blocks * st.f_frsize
    used = (st.f_blocks - st.f_bfree) * st.f_frsize
    return DiskUsage(total,used,free)


print disk_usage('/')
