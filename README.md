# Licode

## 1、说明
* 只支持centos (only support centos)
* 线上系统基本只用centos
* 使用最新ffmpeg替换libav
* 使用c++1x替换boost
* 脚本更友好


## 2、示例 (usage)

	cd scripts
	
	#install deps
	./installCentosDeps.sh
	
	#install erizo
	./installErizo.sh
	
	#install nuve
	./installNuve.sh
	
	#install example
	./installBasicExample.sh
	
	#start licode
	./startLicode.sh
	
	#start basic example
	./startBasicExample.sh
	
	#stop licode
	./stopLicode.sh
	
	#stop basic example
	./stopBasicExample.sh
	
	#restart licode and basic example  ^_^
	./restartAll.sh
