#!/usr/bin/env sh

outputDir="/mnt/c/Users/voznyukva/uin"			# Полный или относительный путь до Каталога с выходными данными вида UUID.txt
dataFile="/mnt/c/Users/voznyukva/data.json"		# Полный или относительный путь и имя файла с входными данными в json
taskFile="/mnt/c/Users/voznyukva/tasks.txt"		# Полный или относительный путь и имя файла с UUID-ами. Одна строка -- один UUID

maxProcs=$(grep -i 'core id' /proc/cpuinfo|wc -l)
mkdir -p $outputDir
rm -rf $outputDir/*
xargs -P ${maxProcs} -a ${taskFile} \
		--process-slot-var=$dataFile \
		--process-slot-var=$outputDir -i sh -c \
		"echo {}; grep '\"orderId\":\"{}\"' ${dataFile}|grep -o '\"uin\":\"[0-9]*\"'|grep -o '[0-9]*' > ${outputDir}/{}.txt"
result="result_$(date +%F_%H:%M:%S).txt"
touch $result
basename -s .txt $outputDir/*|xargs -P 1 -i sh -c 'echo {};cat uin/{}.txt'>$result
