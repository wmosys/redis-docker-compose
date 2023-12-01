# Redis Docker 集群



## 快速开始

打开命令窗口执行：

1. 修改 Redis NAT 配置文件

  ```
cluster-announce-ip [宿主机IP]
cluster-announce-port [Dokcer 映射端口（未修改端口可以不配置）]
cluster-announce-bus-port [Dokcer 映射业务端口（未修改端口可以不配置）]
  ```

2. 构建容器

  ```shell
# 构建容器
docker-compose -f docker-compose.yml up -d
  ```

3. 进入容器构建集群

  ```shell
# 进入 Redis 容器
docker exec -it redis-master1 /bin/sh
  
# 构建集群
redis-cli --cluster create 10.88.11.21:7001 10.88.11.21:7002 10.88.11.21:7003 10.88.11.21:7004 10.88.11.21:7005 10.88.11.21:7006 --cluster-replicas 1

# 构建集群（附带密码）
redis-cli -a 123456 --cluster create 10.88.22.1:7001 10.88.22.1:7002 10.88.22.1:7003 10.88.22.1:7004 10.88.22.1:7005 10.88.22.1:7006 --cluster-replicas 1
  ```

  

## Redis NAT 参数

在 Redis Cluster 集群模式下，集群的节点需要告诉用户或者是其他节点连接自己的IP和端口。

默认情况下，Redis会自动检测自己的IP和从配置中获取绑定的PORT，告诉客户端或者是其他节点。而在Docker环境中，如果使用的不是host网络模式，在容器内部的IP和PORT都是隔离的，那么客户端和其他节点无法通过节点公布的IP和PORT建立连接。

![](https://raw.githubusercontent.com/Mosys/markdowm-img/master/img/6107DE11-0984-4B84-87D0-1CF8B02D6385.png)

Redis 3.0 Cluster 在 Docker 中的情况



因此 Redis 4.0 中增加了三个配置

```
cluster-announce-ip：要宣布的IP地址。
cluster-announce-port：要宣布的数据端口。
cluster-announce-bus-port：要宣布的集群总线端口
```

如果配置了以后，Redis节点会将配置中的这些IP和PORT告知客户端或其他节点。而这些IP和PORT是通过Docker转发到容器内的临时IP和PORT的。

![](https://raw.githubusercontent.com/Mosys/markdowm-img/master/img/E162DD1D-0640-4000-A8E8-F192AEA02C3F.png)

Redis 4.0 Cluster 在 Docker 中