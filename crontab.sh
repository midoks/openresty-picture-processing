# 凌晨2点执行，查找目录下面7天内没有被访问的文件并删除，释放空间
0 2 * * * find /www/app/thumbnail -atime -7 | xargs rm -rf