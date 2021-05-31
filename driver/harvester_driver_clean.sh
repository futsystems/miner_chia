#/bin/bash

echo "Clean Harvester Driver"

path_list=$(ls /mnt/plots)
for path in $path_list
 do
	echo "path:"$path
	cd /mnt/plots/$path
	#find . -name "*" -type f -name *.tmp
	#find . -name "*" -type f -name *.tmp | xargs -n 1 rm -f
	find . -name "*" -type f -size -102G | xargs -n 1 rm -f
done

