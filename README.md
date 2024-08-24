F5 XC Multi-VPC AWS lab

Experimental deployment of F5 XC SM v2 with SLI's in different VPC's 


## Limits

```
$ ./describe-ec2-instance-type.sh t3.*
instance_type=(t3.*) ...
-------------------------------------------------
|             DescribeInstanceTypes             |
+-------------+-------------------+--------+----+
|  t3.nano    |  Up to 5 Gigabit  |  0.032 |  2 |
|  t3.micro   |  Up to 5 Gigabit  |  0.064 |  2 |
|  t3.small   |  Up to 5 Gigabit  |  0.128 |  3 |
|  t3.medium  |  Up to 5 Gigabit  |  0.256 |  3 |
|  t3.large   |  Up to 5 Gigabit  |  0.512 |  3 |
|  t3.xlarge  |  Up to 5 Gigabit  |  1.024 |  4 |
|  t3.2xlarge |  Up to 5 Gigabit  |  2.048 |  4 |
+-------------+-------------------+--------+----+
```

```
$ ./describe-ec2-instance-type.sh c5.*
instance_type=(c5.*) ...
---------------------------------------------------
|              DescribeInstanceTypes              |
+--------------+--------------------+-------+-----+
|  c5.large    |  Up to 10 Gigabit  |  0.75 |  3  |
|  c5.xlarge   |  Up to 10 Gigabit  |  1.25 |  4  |
|  c5.2xlarge  |  Up to 10 Gigabit  |  2.5  |  4  |
|  c5.4xlarge  |  Up to 10 Gigabit  |  5.0  |  8  |
|  c5.12xlarge |  12 Gigabit        |  12.0 |  8  |
|  c5.9xlarge  |  12 Gigabit        |  12.0 |  8  |
|  c5.metal    |  25 Gigabit        |  25.0 |  15 |
|  c5.24xlarge |  25 Gigabit        |  25.0 |  15 |
|  c5.18xlarge |  25 Gigabit        |  25.0 |  15 |
+--------------+--------------------+-------+-----+
```

[./describe-ec2-instance-type.sh \*)](./all-instances.txt)
