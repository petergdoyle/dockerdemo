

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
  '/usr/hadoop/default/bin/hadoop version'
)

for cmd in "${cmds[@]}"
do
  eval $cmd
  if [ $? -eq 127 ]; then
    echo -e "\e[1;31mcannot run $cmd. it doesn't look like it was installed successfully\e[0m"
  fi
done
