#!/bin/bash

if [ -z $1 ] 
then
  echo "Enter path to the file: replace_mkup.sh ../techdocs/mainSpace/"
  exit 1
else
  for i in $( ls $1 ); do
    echo "File -> $i"
      while read line
  	do
      	name=$line

	if [[ $name == *"//"* ]]; then
	  name=$(echo $name | sed 's/\/\//_/g')
          echo "o:=> $line"
          echo "n:=> $name"
          echo ""
	fi

	if [ "$(echo -n $name | tail -c 3)" = "===" ]; then
           name=$(echo $name | sed 's/^===/h3. /')
           name=$(echo $name | sed 's/===/ /')
	   echo "o:=> $line"
	   echo "n:=> $name"
	   echo ""
	else 
	  if [ "$(echo -n $name | tail -c 2)" = "==" ]; then
	   name=$(echo $name | sed 's/^==/h2. /')
           name=$(echo $name | sed 's/==/ /')
	   echo "o:=> $line"
           echo "n:=> $name" 
	   echo ""
	  else 
	    if [ "$(echo -n $name | tail -c 1)" = "=" ]; then
              name=$(echo $name | sed 's/^=/h1. /')
              name=$(echo $name | sed 's/=/ /')
	      echo "o:=> $line"
              echo "n:=> $name" 
	      echo ""
  	    else
		if [[ $name == *"[[@"* ]]; then
		  if [[ $(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\]\])') == *"|"* ]]; then
		  name=$(echo -n "$name" | sed "s/\[\[\@/\[\[/")
		  part1=$(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\|)')
		  part2=$(echo -n "$name" | grep -o -P '(?<=\|).*(?=\]\])')
		  echo "o:=> ${line}"
		  part0=$(echo -n "$name" | awk -F[ {'print $1'})
                  part3=$(echo -n "$name" | awk -F] {'print $2'})
		  name="${part0}[$part2|$part1]$part3"
		  echo "n:=> $name"
		  echo ""
		  fi
		else
		  if [[ $name == *"[["* ]]; then
		    if [[ $(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\]\])') == *"|"* ]]; then
                      part1=$(echo -n "$name" | grep -o -P '(?<=\[\[).*(?=\|)')
                      part2=$(echo -n "$name" | grep -o -P '(?<=\|).*(?=\]\])')
                      echo "o:=> ${line}"
                      part0=$(echo -n "$name" | awk -F[ {'print $1'})
                      part3=$(echo -n "$name" | awk -F] {'print $2'})
		      name="${part0}[$part2|$part1]$part3"
                      echo "n:=> $name"
                      echo ""
                    else
		      name=$(echo -n "$name" | sed 's/\[\[/\[/')
		      name=$(echo -n "$name" | sed 's/\]\]/\]/')
                      echo "o:=> ${line}"
                      echo "n:=> ${name}"
                      echo ""
                    fi
                  fi 
		fi
            fi
	  fi	
        fi
	

      done < ${1}${i}
  done
fi
