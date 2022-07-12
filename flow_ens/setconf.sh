# get arguments
defaultYAML="$1"
thisYAML="$2"
rootKey="$3"
key1="$4"
getYAMLNode="python3 getYAMLNode.py"

key="`${getYAMLNode} ${defaultYAML} ${thisYAML} ${rootKey}.${key1} -o key`"
value="`${getYAMLNode} ${defaultYAML} ${thisYAML} ${rootKey}.${key1} -o value`"

#export $key=\"$value\"
export $key=$value
