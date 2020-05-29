import psutil

print("Net io counters:", psutil.net_io_counters(pernic=True))
print("Net if address:", psutil.net_if_addrs())
print("Net if Stats:", psutil.net_if_stats())
