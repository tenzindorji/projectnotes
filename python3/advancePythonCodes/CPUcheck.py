import psutil

print("CPU times:", psutil.cpu_times())
print("CPU counts:", psutil.cpu_count())
print("CPU physical counts:", psutil.cpu_count(logical=False))
print("CPU stats:", psutil.cpu_stats())
print("CPU Frequency:", psutil.cpu_freq())

print("Memory:", psutil.virtual_memory())
