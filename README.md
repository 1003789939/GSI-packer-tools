# GSI-packer-tools
# 用途
    将GSI镜像打包成可供recovery刷写的rom包，目的是为了解决动态分区无法直接通过rec刷写gsi镜像

    目前仅在小米10、Android10上测试通过，其他机型自测

# 先决条件:
    1.gsi镜像(目前仅支持sparse image)
    2.带有system分区镜像的rom包(可选)
    3.Windows下python3环境(full版内置)
    

# 用法:
    1.执行build.bat
    2.将gsi镜像重命名为gsi.img放入input文件夹
    3.将底包放入input文件夹(可选)
    3.按提示操作即可
    
    
    注：1.测试时底包用的官方全量包    
        2.如提示缺少依赖(找不到msys.....)，请将bin.7z解压后合并到工具的bin目录
    
    
