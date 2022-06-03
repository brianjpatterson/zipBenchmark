#!/bin/bash
function joinByChar {
  local IFS="$1"
  shift
  echo "$*"
}
declare -a toexec
readarray toexec </root/devops/commands.txt
IFS=$'\n' toexec=($(sort <<<"${toexec[*]}"))
unset IFS
declare -a usize
declare -a final
declare -a dirlist=(*)
export LC_COLLATE=C
IFS=$'\n' dirlist=($(sort -V <<<"${dirlist[*]}"))
unset IFS
for ((i = 0; i < ${#dirlist[@]}; i++)); do
  usize[$i]="$(stat --printf="%s" "${dirlist[$i]}")"
  #final+=("$(joinByChar ',' "${dirlist[$i]}" "${usize[$i]}")");
done
declare -a toCompress
for ((j = 0; j < ${#toexec[@]}; j++)); do
  program+=(${toexec[$j]})

  for ((i = 0; i < ${#dirlist[@]}; i++)); do
    if [ "$program" == "gzip" ]; then
      newval=$(joinByChar ' ' "${toexec[$j]} -c" "${dirlist[$i]}")
      newval=$(joinByChar ' ' "$newval" ">")
      newval=$(joinByChar ' ' "$newval" "${dirlist[$i]}.gz")
    else
      newval=$(joinByChar ' ' "${toexec[$j]}" "${dirlist[$i]}")
      newval=$(joinByChar ' ' "$newval" ">")
      newval=$(joinByChar ' ' "$newval" "${dirlist[$i]}.bzip2")
    fi
    toCompress[$i]="$newval"
    toCompress[$i]="${toCompress[$i]//[$'\t\r\n']/}"
    eval "${toCompress[$i]}"
  done
  declare -a dd=(*.gz)
  IFS=$'\n' dd=($(sort -V <<<"${dd[*]}"))
  unset IFS

  for ((i = 0; i < ${#dd[@]}; i++)); do
    csize[$i]="$(stat --printf="%s" "${dd[$i]}")"
    ratio=$((${usize[$i]} * 100))
    ratio1=$((${csize[$i]} * 100))
    ratio2=$(echo "scale=9; $ratio1 / $ratio" | bc -l)

    ratio3=$(printf "%.2f%%\n" "$ratio2" | sed 's/\.//')
    ratio4=$(echo "$ratio3" | sed -r 's/0*([0-9]*)/\1/')
    something=("$(joinByChar ',' "${toexec[$j]}" "${dirlist[$i]}")")
    other=("$(joinByChar ',' "$something" "$ratio4")")
    final+=("${other//[$'\t\r\n']/}")
  done
done
for i in "${!final[@]}"; do
  printf "%s\n" "${final[$i]}"

done
