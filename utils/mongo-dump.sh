#!/bin/bash


if [ $# -ne 2 ] && [ $# -ne 3 ] ; then
   printf '%s\n' "Usage: $0 database_name [dir_to_store]"
   printf '%s\n' "If no output directory is passed then output directory will be default "${out_dir}
   mkdir ${MONGODB_HOME}${1}$(date +%Y%m%d%H%M)
   out_dir=${MONGODB_HOME}${1}$(date +%Y%m%d%H%M)
fi

db=$1

if [ $# -eq 2 ] || [ $# -eq 3 ]
then 
   if [ $# -eq 3 ]
   then 
     prefix=$3
     out_dir=${2}"/"${db}"-"${prefix}"-"$(date +%Y-%m-%d-%H:%M)
   else
     out_dir=${2}"/"${db}"_"$(date +%Y-%m-%d-%H:%M)
   fi
fi


if [ ! $out_dir ]; then
        out_dir="./"
else
        mkdir -p $out_dir
fi


tmp_file="fadlfhsdofheinwvw.js"
echo "print('_ ' + db.getCollectionNames())" > $tmp_file
cols=`mongo $db $tmp_file | grep '_' | awk '{print $2}' | tr ',' ' '`
for c in $cols
do
    mongoexport -d $db -c $c -o "$out_dir/exp_${db}_${c}.json"
done
rm $tmp_file

