## Mongodb Sharding
- what is sharding
  - Sharding is means of partitioning your data across multiple servers
  - Horizontal scale out across regions
  - data distribution
  - Elastic

- why sharding
  -
- How?

- Shard Key
  - Determines distribution of data among the cluster's shards

- Sharding fears
    - Shard key
    - Selecting the wrong shard key
      - Data won't be evenly distributed, directly affecting performance and efficiency
    - Could not modify the Shard key
    - Joining the Data

- New Sharding Features
  - Flexibility in Sharding
    - From 4.2 release, support mutable Shard key values
    - Refinable Shard key

    - Compound Hashed Shard key

- Consistent Sharding
  - Memcache

- Create Index on a Shard
