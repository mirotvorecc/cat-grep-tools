#!/bin/bash

COUNT=0
SUCCESS=0
FAIL=0
DIFF=""

# b E e n s T t v --number-nonblank --number --squeeze-blank

declare -a tests=(
    "VAR test1.txt"
    "VAR test2.txt"
    "VAR test3.txt"
    "VAR test4.txt"
    "VAR test5.txt"
    "VAR test6.txt"
    "VAR no_file.txt"
    "VAR test1.txt test2.txt"
    "VAR test2.txt test4.txt"
    "VAR test2.txt test3.txt test4.txt"
    "VAR test4.txt test5.txt"
    # "VAR test2.txt test1.txt test6.txt"
    "VAR test4.txt no_file.txt"
)

flag=(
    "b"
    "-number-nonblank"
    "E"
    "e"
    "n"
    "-number"
    "s"
    "-squeeze-blank"
    "t"
    "T"
    "v"
)

print() {
    echo "
      
      str          !
      
      
      
      
      end."> test1.txt

echo "
    str          !
    
    
    
    
      end.
    
    
    
    " > test2.txt

echo "
    str          !
    
()
   ()  
()
  end.

" > test3.txt

echo "
str          !






  end.



" > test4.txt

echo "0 - ( )
1 - ()
2 - ()
3 - ()
4 - ()
5 - ()
6 - ()
7 - ()
8 - ()
9 - (	)
10 - (
)
11 - ()
12 - ()
13 - (
)
14 - ()
15 - ()
16 - ()
17 - ()
18 - ()
19 - ()
20 - ()
21 - ()
22 - ()
23 - ()
24 - ()
25 - ()
26 - ()
27 - ()
28 - ()
29 - ()
30 - ()
31 - ()
32 - ( )
33 - (!)
34 - (\")
35 - (#)
36 - ($)
37 - (%)
38 - (&)
39 - (\')
40 - (()
41 - ())
42 - (*)
43 - (+)
44 - (,)
45 - (-)
46 - (.)
47 - (/)
48 - (0)
49 - (1)
50 - (2)
51 - (3)
52 - (4)
53 - (5)
54 - (6)
55 - (7)
56 - (8)
57 - (9)
58 - (:)
59 - (;)
60 - (<)
61 - (=)
62 - (>)
63 - (?)
64 - (@)
65 - (A)
66 - (B)
67 - (C)
68 - (D)
69 - (E)
70 - (F)
71 - (G)
72 - (H)
73 - (I)
74 - (J)
75 - (K)
76 - (L)
77 - (M)
78 - (N)
79 - (O)
80 - (P)
81 - (Q)
82 - (R)
83 - (S)
84 - (T)
85 - (U)
86 - (V)
87 - (W)
88 - (X)
89 - (Y)
90 - (Z)
91 - ([)
92 - (\)
93 - (])
94 - (^)
95 - (_)
96 - (\`)
97 - (a)
98 - (b)
99 - (c)
100 - (d)
101 - (e)
102 - (f)
103 - (g)
104 - (h)
105 - (i)
106 - (j)
107 - (k)
108 - (l)
109 - (m)
110 - (n)
111 - (o)
112 - (p)
113 - (q)
114 - (r)
115 - (s)
116 - (t)
117 - (u)
118 - (v)
119 - (w)
120 - (x)
121 - (y)
122 - (z)
123 - ({)
    124 - (\|)
125 - (})
126 - (~)
127 - ()
" > test5.txt

echo "$$$$
$$
$$$$$


¥
是我
§«Õϖ‡€
$$$$
$

$$
$$
$" > test6.txt
}

testing() {
    print
    test_str=$(echo $@ | sed "s/VAR/$var/")
    ./s21_cat $test_str > test_s21_cat.log
    cat $test_str > test_sys_cat.log
    DIFF="$(diff -s test_s21_cat.log test_sys_cat.log)"
    (( COUNT++ ))
    if [ "$DIFF" == "Files test_s21_cat.log and test_sys_cat.log are identical" ]
      then
      (( SUCCESS++ ))
      echo "TEST: $test_str"
      echo "F: $FAIL / S: $SUCCESS / ALL: $COUNT"
      else
      (( FAIL++ ))
      echo "TEST: $test_str"
      echo "F: $FAIL / S: $SUCCESS / ALL: $COUNT"
    fi
    rm test_s21_cat.log test_sys_cat.log *.txt
}

# b E e n s T t v --number-nonblank --number --squeeze-blank

# 1 flags

for var1 in "${flag[@]}"
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 2 flags

for var1 in "${flag[@]}"
do
    for var2 in "${flag[@]}"
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                testing "$i"
            done
        fi
    done
done

# # 3 flags

for var1 in "${flag[@]}"
do
    for var2 in "${flag[@]}"
    do
        for var3 in "${flag[@]}"
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var3 != $var1 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    testing "$i"
                done
            fi
        done    
    done
done

# # # 4 flags

for var1 in "${flag[@]}"
do
    for var2 in "${flag[@]}"
    do
        for var3 in "${flag[@]}"
        do
            for var4 in "${flag[@]}"
            do
                if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var3 != $var4 ] && [ $var4 != $var1 ]
                then
                    for i in "${tests[@]}"
                    do
                        var="-$var1 -$var2 -$var3 -$var4"
                        testing "$i"
                    done
                fi
            done
        done
    done
done

# # 5 flags

for var1 in "${flag[@]}"
do
    for var2 in "${flag[@]}"
        do
        for var3 in "${flag[@]}"
            do
            for var4 in "${flag[@]}"
                do
                for var5 in "${flag[@]}"
                    do
                    if [ $var1 != $var2 ] && [ $var2 != $var3 ] \
                    && [ $var3 != $var4 ] && [ $var4 != $var5 ] \
                    && [ $var5 != $var1 ]
                    then
                        for i in "${tests[@]}"
                        do
                        var="-$var1 -$var2 -$var3 -$var4 -$var5"
                        testing "$i"
                        done
                    fi
                done                
            done
        done
    done
done

echo "FAIL: $FAIL"
echo "SUCCESS: $SUCCESS"
echo "ALL: $COUNT"