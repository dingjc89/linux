#!/bin/bash

########################################
#用管理员权限执行这个脚本
#./rollback 090643 这个shell脚本带一个参数，
#指的是要回滚备份日期下的文件夹名
#version V1.0
#author Steve
#[2017-06-14]
########################################



#更新项目路径
update_dir='/Users/dingjiacai/Desktop/yiwww/donghu'

#回滚路径
back_bak='donghu_bak'

#回滚日志路径
rollback_dir='rollback'

#回滚日志文件
rollback_log=rollback.log
rollback_add_log=add_file.log

day="`date +%Y%m%d`"
user=www
group=www


now_dir=`dirname $0`

cd $now_dir

[ ! -d $back_bak ] && echo "no $back_bak dir ....." && exit 1
[ ! -d $update_dir ] && echo "no $update_dir dir ....." && exit 1

[ ! -f $rollback_dir/$rollback_log ] && touch $rollback_dir/$rollback_log && chmod 0755 $rollback_dir/$rollback_log
[ ! -f $rollback_dir/$rollback_add_log ] && touch $rollback_dir/$rollback_add_log && chmod 0755 $rollback_dir/$rollback_add_log

find $back_bak -type f |grep '/\.' && exit 1
find $back_bak -type f |xargs ls >/dev/null || exit 1

go_back=$back_bak/$day/$1

echo -e "\n\n### rollback $1 dir on $day ############ " |tee -a $rollback_dir/$rollback_log
echo -e "\n\n### rollback $1 dir on $day ############ " |tee -a $rollback_dir/$rollback_add_log

ls $go_back/*--* |while read s_file
	do
		r_file=`echo $s_file  |sed "s#^#/#;s#--#/#g"`
		d_file=`echo $r_file |sed "s#$go_back/##"`
		echo $d_file
		if [ ! -f $d_file ]; then
			d_dir=`dirname $d_file`
			[ ! -d $d_dir ] && mkdir -p $d_dir && chown $user:$group $d_dir
			/bin/cp $s_file $d_file && chown $user:$group $d_file
			[ $? -eq 0 ] && echo "/bin/cp $s_file $d_file" |tee -a $rollback_dir/$rollback_add_log
		else
			/bin/cp -f $s_file $d_file && chown $user:$group $d_file
			[ $? -eq 0 ] && echo "/bin/cp -f $s_file $d_file" |tee -a $rollback_dir/$rollback_log
		fi
	done


