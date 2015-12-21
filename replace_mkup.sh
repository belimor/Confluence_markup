#!/bin/bash
mydebug="y"

if [ -z $1 ] 
then
  echo "Enter path to the file: replace_mkup.sh ../techdocs/mainSpace/"
  exit 1
else
  cd $1
 # for i in * ; do
  find . -iname "*" | while read i
  do
    if [ "$i" != "." ]; then
    echo " " >> "${i}"
    echo "File: $i"
      while read line
  	do
      	name=$line

	if [[ $name == *"</span>"* ]]; then
	  name="$(echo "$name" | sed -e 's/<[^>]*>//g')"
	  #name=$(echo "$name" | sed 's/<\/span>//g')
          #name=$(echo "$name" | sed "s/<span*>//g")
	  if [ "$mydebug" == "y" ]; then
              echo "o:=> $line"
              echo "n:=> $name"
              echo ""
          fi
	fi

	if [[ $name == *"//"* ]]; then
          if [[ $name == *"http//"* ]] || [[ $name == *"https//"* ]]; then
            name=$(echo $name | sed 's/\/\//_/g')
            if [ "$mydebug" == "y" ]; then
              echo "o:=> $line"
              echo "n:=> $name"
              echo "/////////////"
            fi
            echo "$name" >> "${i}.new"
          fi
        fi
 
	if [[ $name == *"**"* ]]; then
	echo "**"
	needle1="**"
        number_of_occurrences1=$(grep -o "$needle1" <<< "$name" | wc -l)
	echo "$number_of_occurrences1"
	if [ $number_of_occurrences1 -gt 1 ]; then
	  name=$(echo "$name" | sed 's/\*\*/\*/g')
	  if [ "$mydebug" == "y" ]; then
              echo "o:=> $line"
              echo "n:=> $name"
              echo ""
          fi
	fi
	fi
 
	needle="\[\["
	number_of_occurrences=$(grep -o "$needle" <<< "$name" | wc -l)
	if [ "$mydebug" == "y" ]; then
        echo "ns:=> $number_of_occurrences"
	fi

	if [ "$(echo -n $name | tail -c 3)" = "===" ]; then
           name=$(echo $name | sed 's/^===/h3. /')
           name=$(echo $name | sed 's/===/ /')
	   if [ "$mydebug" == "y" ]; then
	     echo "o:=> $line"
	     echo "n:=> $name"
	     echo ""
	   fi
	   echo "$name" >> "${i}.new"
	else 
	  if [ "$(echo -n $name | tail -c 2)" = "==" ]; then
	    name=$(echo $name | sed 's/^==/h2. /')
            name=$(echo $name | sed 's/==/ /')
	    if [ "$mydebug" == "y" ]; then
	      echo "o:=> $line"
              echo "n:=> $name" 
	      echo ""
	    fi
	    echo "$name" >> "${i}.new"
	  else 
	    if [ "$(echo -n $name | tail -c 1)" = "=" ]; then
              name=$(echo $name | sed 's/^=/h1. /')
              name=$(echo $name | sed 's/=/ /')
	      if [ "$mydebug" == "y" ]; then
	        echo "o:=> $line"
                echo "n:=> $name" 
	        echo ""
	      fi
	      echo "$name" >> "${i}.new"
  	    else
	      if [[ $name == *"[[@"* ]] && [ $number_of_occurrences -lt 2 ]; then
	        if [[ $(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\]\])') == *"|"* ]]; then
		  name=$(echo -n "$name" | sed "s/\[\[\@/\[\[/")
		  part1="$(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\|)')"
		  part2="$(echo -n "$name" | grep -o -P '(?<=\|).*(?=\]\])')"
		  part0="$(echo -n "$name" | awk -F[ {'print $1'})"
                  part3="$(echo -n "$name" | awk -F] {'print $2'})"
		  name="${part0}[$part2|$part1]$part3"
		  if [ "$mydebug" == "y" ]; then
		    echo "o:=> ${line}"
		    echo "n:=> $name"
		    echo ""
		  fi
		  echo "$name" >> "${i}.new"
		fi
	      else
	        if [[ $name == *"[["* ]] && [ $number_of_occurrences -lt 2 ]; then
		  if [[ $(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\]\])') == *"|"* ]]; then
                    part1=$(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\|)')
                    part2=$(echo -n "$name" | grep -o -P '(?<=\|).*(?=\]\])')
                    part0=$(echo -n "$name" | awk -F[ {'print $1'})
                    part3=$(echo -n "$name" | awk -F] {'print $2'})
		    name="${part0}[$part2|$part1]$part3"
		    if [ "$mydebug" == "y" ]; then
		      echo "o:=> ${line}"
                      echo "n:=> $name"
                      echo ""
		    fi
   		    echo "$name" >> "${i}.new"
                  else
		    name=$(echo -n "$name" | sed 's/\[\[/\[/')
		    name=$(echo -n "$name" | sed 's/\]\]/\]/')
			if [[ $name == *"[code]"* ]]; then
                        name=$(echo $name | sed 's/\[code\]/\{code:\}/g')
                        fi
		    if [ "$mydebug" == "y" ]; then
                      echo "o:=> ${line}"
                      echo "n:=> ${name}"
                      echo ""
		    fi
		    echo "$name" >> "${i}.new"
                  fi
		else
		  if [[ $name == *"[["* ]]; then
		    name=$(echo -n "$name" | sed 's/\[\[/\[/')
		    name=$(echo -n "$name" | sed 's/\]\]/\]/')
 			if [[ $name == *"[code]"* ]]; then
        		name=$(echo $name | sed 's/\[code\]/\{code:\}/g')
        		fi
		    if [ "$mydebug" == "y" ]; then
		      echo "o:=> ${line}"
                      echo "n:=> ${name}"
                      echo ""
		    fi
		    echo "$name" >> "${i}.new"
		  else
		        if [[ $name == *"[code]"* ]]; then
        		name=$(echo $name | sed 's/\[code\]/\{code:\}/g')
        		fi
		    if [ "$mydebug" == "y" ]; then
		      echo "o:=> ${line}"
		      echo "n:=> ${name}"
                      echo ""
		    fi
		    echo "$name" >> "${i}.new"
		  fi
		fi
	      fi
            fi
	  fi	
        fi

	if [ "$mydebug" == "y" ]; then
	echo "=========================================="
	fi
	j=$i
      done < "${i}"
    fi
  done
fi
echo $name
echo $i
