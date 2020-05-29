import psutil

print("Disc Partition:")
print(psutil.disk_partitions())

print("Disc Usage:")
print(psutil.disk_usage('/'))

print("IO Counter")
print(psutil.disk_io_counters(perdisk=False))
