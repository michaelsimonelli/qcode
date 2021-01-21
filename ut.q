$ cat fs.q
\d .Q

/ extension of .Q.dpft to separate table name & data
/  and allow append or overwrite
/  pass table data in t, table name in n, : or , in g
k)dpfgnt:{[d;p;f;g;n;t]if[~&/qm'r:+en[d]t;'`unmappable];
{[d;g;t;i;x]@[d;x;g;t[x]i]}[d:par[d;p;n];g;r;<r f]'!r;
@[;f;`p#]@[d;`.d;:;f,r@&~f=r:!r];n}

/ generalization of .Q.dpfnt to auto-partition and save a multi-partition table
/  pass table data in t, table name in n, name of column to partition on in c
k)dcfgnt:{[d;c;f;g;n;t]*p dpfgnt[d;;f;g;n]'?[t;;0b;()]',:'(=;c;)'p:?[;();();c]?[t;();1b;(,c)!,c]}

\d .

r:flip`date`open`high`low`close`volume`sym!("DFFFFIS";",")0:
w:.Q.dcfgnt[`:db;`date;`sym;,;`stats]
.Q.fs[w r@]`:file.csv
