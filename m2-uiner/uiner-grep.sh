#!/usr/bin/env sh

outputDir="./uin"			# Полный или относительный путь до Каталога с выходными данными вида UUID.txt
dataFile="./date.json"		# Полный или относительный путь и имя файла с входными данными в json
taskFile="./tasks.txt"		# Полный или относительный путь и имя файла с UUID-ами. Одна строка -- один UUID

maxProcs=$(grep -i 'core id' /proc/cpuinfo|wc -l)
mkdir -p $outputDir
xargs -P ${maxProcs} -a ${taskFile} \
		--process-slot-var=$dataFile \
		--process-slot-var=$outputDir -i sh -c \
		"echo {};grep '\"orderId\":\"{}\"' $dataFile|grep -o '\"uin\":\"[0-9]*\"'|grep -o '[0-9]*'>$outputDir/{}.txt"
