# Examples
1. `=A2&"/Archive/AR_"&B2&"_"&TEXT(IF(K2<>"",K2,C2),"yyyymmdd")&".pbix"`
   1. cell reference: =A2
   2. static text: "<text>"
   3. string concatenator: &
   4. IF(<cell><><value>,<case 1>,<case 2>)