# variables
- it can be defined any where in the manifest file
```
node default {
  package {'nginx':
  ensured => 'installed',
}
$test = "Hello world"
file {'/tmp/log.txt':
content => $test,
mode => '0644'
}
}
```

Double and single quotes meaning
`$my_var = 'Hello '`
`"${my_var}world"` translate to 'Hello world'
`'${my_var}world'` translate to '${my_var}world' , it takes as it is

variable to reference by ${}

# Resources:
```
file {'/etc/motd':
  ensure => 'file',
  owner => 'root',
  group => 'root',
  mode => '0644',
}
```


# package:
```
package {'mysql-server':
  ensure => 'installed',
  }
```

# Services and Facts
- Configuration of service config file after package is install.
```
file {'/var/lib/pgsql/data/postgresql.conf':
  ensure => 'file',
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => 'listen_addresses = '192.168.0.10''
}
```
- facts
  - Puppets automatically creates a sets of variable for you called facts.
    `facter -p` will list the system information of the node.


- using facts variable to configure the config
```
file {'/etc/dummy/dummy.cfg':
  ensure => 'file',
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => 'Running on host $hostname',
}
```
- starting the service
```
service {'sshd':
  ensure => 'running',
  enable => 'true',
  }
```
# Resource relationship and Refresh event
- it is achieved by using 'before/require' or 'notify/subscribe'
- It should be Capitalized 
```
package { 'postgresql-server':
  ensure => installed,
  before => File['/var/lib/pgsql/data/postgresql.conf']
}

file { '/var/lib/pgsql/data/postgresql.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => "listen_addresses = '192.168.0.10'\n",
  #require => Package['postgresql-server'],
  notify => Service['postgresql']

}

service { 'postgresql':
  ensure => running,
  enable => true,
 # subscribe => File['/var/lib/pgsql/data/postgresql.conf']
}
```


# loops
```
node default {
    $packages = ['apache2', 'mysql-server' ]
    package {$packages:
    ensured => installed,
  }
}
```

# Conditions
```
node default {
  exec {"conditions":
  command => "/bin/echo apache is installed > /tmp/log.txt",
  onlyif => "/bin/which apache2",
  } #passing command to agent
}
```
```
node default {
  exec {"conditions":}
  command => "/bin/echo apache is not installed > /tmp/log/txt",
  unless => "/bin/which apache2",
}
```

# Class
```
class users {
  user {'nameoftheuser':
  ensure => present,
  uid => '101',
  shell => '/bin/bash',
  home => '/home/nameoftheuser',
  }
}

node 'node1' {
  class {nameoftheuser:}
}


node 'node2' {
  include nameoftheuser # class can be declare this way as well using include keyword.
}
```

# Parameterized Class

```
class users ($name) {
  user {'$name':
  ensure => present,
  uid => '101',
  shell => '/bin/bash',
  home => '/home/$name',
}
}
node 'node1' {
  class {'user_profile':  
  name => "abcd",
  }
}

node 'node2' {
  class {"user_profile":
  name => "xzy",
}
}
```

# :: Namespace segments is same as "/" in linux file system
- reference  
https://puppet.com/docs/puppet/6.17/lang_namespaces.html#:~:text=Puppet%20class%20and%20defined%20type,%2F%20)%20in%20a%20file%20path.

# Module
- module name should contain only lower case, number and underscore
- should not contain namespace(::)



# Hiera
- configuration software from puppetlab
- separates configuration code from functionality
- hiera has all the value pair configurations in a database(yaml or json)

1. Three layer hiera
  1. Global layer (applied configuration to all)
  2. Environment layer(configuration applied to environment)
  3. module layer(configuration applied to module) , keys values are lookup within modules
2. Pros and Cons
  1. Pros   
    - Separation between data and code
  2. cons
    - confusing
    - yaml is bad
    - hard to debugg

3. What is hiera used for
  - Explicit data lookup  
    ```
    #get a value,
    #...failed if not found
    $x = lookup('key')
    # .. verify data type
    $x = lookup ('key', Array)
    #...return default if not found
    $x = lookup('key', Array, first, [blue]) # first found, if not return default value blue
    ```
  - Automatic Parameter lookup (APL) - dynamically getting values by classes
    push value which needs to compute, also recommended way of using hiera
    ```
    class mymodule::myclass($myparam) {
      #...

    }
    include 'mymodule::myclass'
    ```
    Automatically looks up mymodule::myclass::myparam when value is not given

4. CLI for Hiera 5
`puppet lookup`
