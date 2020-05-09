# 实验四：shell脚本编程基础
## 一、实验内容
- [x] 任务一：用bash编写一个图片批处理脚本，实现以下功能：
    - [x] 支持命令行参数方式使用不同功能
    - [x] 支持对指定目录下所有支持格式的图片文件进行批处理
    - [x] 支持以下常见图片批处理功能的单独使用或组合使用
        - [x] 支持对jpeg格式图片进行图片质量压缩
        - [x] 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
        - [x] 支持对图片批量添加自定义文本水印
        - [x] 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
        - [x] 支持将png/svg图片统一转换为jpg格式图片
- [x] 任务二：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
    - [x] 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
    - [x] 统计不同场上位置的球员数量、百分比
    - [x] 名字最长的球员是谁？名字最短的球员是谁？
    - [x] 年龄最大的球员是谁？年龄最小的球员是谁？
- [x] 任务三：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
    - [x] 统计访问来源主机TOP 100和分别对应出现的总次数
    - [x] 统计访问来源主机TOP 100 IP和分别对应出现的总次数
    - [x] 统计最频繁被访问的URL TOP 100
    - [x] 统计不同响应状态码的出现次数和对应百分比
    - [x] 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
    - [x] 给定URL输出TOP 100访问来源主机

## 二、实验环境
- Ubuntu 18.04.4 Server 64bit

## 三、实验过程及结果
- 结果在[travis](https://travis-ci.com/github/Y1u2e17/shell0504/builds/164762625)查看

## 参考资料
- [CUCCS/linux-2019-Lyc-heng](https://github.com/CUCCS/linux-2019-Lyc-heng/blob/chap0x04/chap0x04/%E5%AE%9E%E9%AA%8C%E6%8A%A5%E5%91%8A.md
)
- [Linux awk 命令](https://www.runoob.com/linux/linux-comm-awk.html)
- [linux命令--查找与统计（grep、awk、sort、uniq、wc）](https://blog.csdn.net/hshuihui/article/details/77915398)
- [linux通配符和正则表达式](https://blog.csdn.net/youmatterhsp/article/details/80528761)