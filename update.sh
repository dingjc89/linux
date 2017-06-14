#!/bin/bash

#######################################
#用管理员权限执行这个脚本
#version V1.0
#author Steve
#[2017-06-14]
########################################



# 更新项目路径
update_dir='/Users/dingjiacai/Desktop/yiwww/donghu'

#原站文件备份目录
bak_dir='donghu_bak'

#更新内容路径
source_dir='source'

source_bak='source_bak'

#版本更新新增文件历史
file_log=add_file.log

#更新日志
update_file=update.log

user=www
group=www
update_time="`date +%Y%m%d-%H%M%S`"
day="`date +%Y%m%d`"
day_time="`date +%H%M%S`"

now_dir=`dirname $0`

cd $now_dir

[ ! -d $update_dir ] && echo "no $update_dir dir ........" && exit 1
[ ! -d $bak_dir ] && echo "no $bak_dir dir ........" && exit 1
[ ! -d $source_dir ] && echo "no $source_dir dir ........" && exit 1

#新增日志文件是否存在，不存在创建
[ ! -f $file_log ] && touch $file_log

go_back=$now_dir/$file_log

#更新日志文件是否存在，不存在创建
[ ! -f $update_file ] && touch $update_file
mkdir -p $bak_dir/$day/$day_time
find $source_dir -type f |grep '/\.' && exit 1
find $source_dir -type f |xargs ls >/dev/null || exit 1

echo -e "\n\n### $update_time #####################" |tee -a $update_file

echo -e "\n\n### $update_time #####################" |tee -a $go_back

find $source_dir -type f | while read s_file
	do
		#获取要更新的旧文件 
		d_file=`echo $s_file |sed "s#$source_dir#$update_dir#"`
		if [ -f $d_file ];then
			b_file=`echo $d_file |sed "s#/#--#g;s/^--//"`
		    /bin/cp $d_file $bak_dir/$day/$day_time/$b_file
		else
		    d_dir="`dirname $d_file`"
		    [ ! -d $d_dir ] && mkdir -p $d_dir && chown $user:$group $d_dir
			echo $d_file >> $go_back
		fi
		/bin/cp -f $s_file $d_file  && chown $user:$group $d_file

		[ $? -eq 0 ] && echo "/bin/cp -f $s_file $d_file" |tee -a $update_file
	done

[ ! -d $source_bak ] && mkdir $source_bak
mv $source_dir $source_bak/donghu_$update_time 

[ $? -eq 0 ] && echo "mv $source_dir $bak_dir/donghu_$update_time" |tee -a $update_file
