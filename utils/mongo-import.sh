#!/bin/zsh

basedir=$1

if [ "$#" -ne 1 ]; then
    printf '%s\n' "Usage: ./mongo-import.sh <directory of json files to import to mongo>"
    exit 1
fi

printf '%s\n' "basedir="${basedir}

if ! [ -n "$(ls -A $basedir | grep .json 2>/dev/null)" ]; then 
    printf '%s\n' "the directory '"${basedir}"' has no json files"
    exit 1
fi
for filename in $(ls $basedir | grep .json) ; do 
   printf '%s\n' "processing file '$filename'";

   arr=($(echo $filename | sed 's/^exp_\([^_]*\)_\(.*\).json/ \1 \2/g')); 
   db=${arr[1]} 
   c=${arr[2]} 

#   printf '%s\n' $db
#   printf '%s\n' $c
    
   printf '%s\n' "importing... 'mongoimport -d "${db}" -c "${c}" --file "${basedir}"/"${filename}"'"
   mongoimport --host=127.0.0.1 -d $db -c $c --file ${basedir}"/"${filename}
done
