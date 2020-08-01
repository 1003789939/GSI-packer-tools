# GSI-packer-tools
# 用途
    将GSI镜像打包成可供recovery刷写的rom包，目的是为了解决动态分区无法直接通过rec刷写gsi镜像

    目前仅在小米10上测试通过，其他机型自测

# 先决条件:
    1.gsi镜像
    2.带有system分区镜像的rom包(后续支持无system分区镜像rom)
    3.Windows下python3环境

# 用法:
    1.将gsi镜像重命名为gsi.img并和底包一起放入input文件夹
    2.执行build.bat,按提示操作即可
    
    注：测试时底包用的官方全量包
    
    
    
