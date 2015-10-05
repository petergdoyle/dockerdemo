

cmds=(
  'docker --version' \
  'docker-compose version' \
  'node --version' \
  'java -version' \
  'mongo --version' \
  'mvn -version' \
  'spring version' \
  '/opt/pivotal/spring-xd/xd/bin/xd-admin' \
  '/usr/storm/default/bin/storm version' \
  '/usr/hadoop/default/bin/hadoop version' \
  '/usr/kafka/default/bin/kafka-run-class.sh' \
  'redis-cli --version'
)

for cmd in "${cmds[@]}"
do
  eval $cmd
  if [ $? -eq 127 ]; then
    echo -e "\e[1;31mcannot run $cmd. it doesn't look like it was installed successfully\e[0m"
  fi
done


cmd='docker --version'
eval $cmd > /dev/null 2>&1
if [ $? -eq 127 ]; then

fi
