for i in *.png
do
	echo $i
	mv "$i" "$(echo $i | sed 's/-//;')"
done

