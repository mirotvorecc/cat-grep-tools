#!/bin/bash

COUNT=0
SUCCESS=0
FAIL=0
DIFF=""

tests=(
"Documents test1.txt"
"Washington test1.txt VAR"
"Found no_file.txt VAR"
"his test1.txt VAR test2.txt"
"general test1.txt test2.txt VAR no_file.txt"
"DePaRtMeNt test1.txt -e VAR"
"-e House -e '[0-9]' s21_grep.c test2.txt VAR"
"-f reg.txt test1.txt VAR"
"-f reg.txt -e department -e test s21_grep.c test1.txt VAR"
"-f no_file_reg.txt -e while -e void s21_grep.c test2.txt no_file_txt VAR"
)

testing()
{
    echo "failure
    OFFICE
    biden
    it was cooperating" > reg.txt

    echo "Biden Lawyers Found Classified Material at His Former Office
    The White House said it was cooperating as the Justice Department scrutinizes the matter.
    WASHINGTON — President Biden's lawyers discovered “a small number” of classified documents in his former office at 
    a Washington think tank last fall, the White House said on Monday, 
    prompting the Justice Department to scrutinize the situation to determine how to proceed.
    -e-r-f-f-t-t-tkf-kf-k-kqw-wqe-=-q-o87370898jo cp test1.txt Reg.tXt Test2.TxT
    The inquiry, according to two people familiar with the matter, 
    is a type aimed at helping Attorney General Merrick B. Garland decide whether to appoint a special counsel, 
    like the one investigating former President Donald J. Trump's hoarding
    of sensitive documents and failure to return all of them." > test1.txt

    echo "B;mom;omkmw ---eeeel;ko;km mmkolkmlnm:LALKMSKMLKMBDBDUDINMENDBIDENORLFHIS
    uKJWUmdje Ujwj IOWIJFMA:FFAPPOPFIPFLELFAIELAEk  
    as test .t s tsttest1.txtTEST2.txt" > test2.txt

    test_str=$(echo $@ | sed "s/VAR/$var/")
    ./s21_grep $test_str > test_s21_grep.log
    grep $test_str > test_sys_grep.log
    DIFF="$(diff -s test_s21_grep.log test_sys_grep.log)"
    (( COUNT++ ))
    if [ "$DIFF" == "Files test_s21_grep.log and test_sys_grep.log are identical" ]
    then
      (( SUCCESS++ ))
      echo "TEST: $test_str"
      echo "F: $FAIL / S: $SUCCESS / ALL: $COUNT"
    else
      (( FAIL++ ))
      echo "TEST: $test_str"
      echo "F: $FAIL / S: $SUCCESS / ALL: $COUNT"
    fi
    rm test_s21_grep.log test_sys_grep.log *.txt
}

# 1 flag

for var1 in v c l n h s i
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 3 flags

for var1 in v c l n h s i
do
    for var2 in v c l n h s i
    do
        for var3 in v c l n h s i
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    testing $i
                done
            fi
        done
    done
done

# 2 splitted flags

for var1 in v c l n h s i
do
    for var2 in v c l n h s i
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1$var2"
                testing $i
            done
        fi
    done
done

echo "FAIL: $FAIL"
echo "SUCCESS: $SUCCESS"
echo "ALL: $COUNT"
