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



.ut.repeat:{ .ut.enlist[x]!count[x]#y };

.ut.cast:{ x $ { $[(::)~x; string;] x} each y };

.ut.default:{ $[.ut.isNull x; y; x] };

.ut.xfunc:{ (')[x; enlist] };

.ut.xposi:{ .ut.assert[not .ut.isNull x y; "positional argument (",(y$:),") '",(z$:),"' required"]; x y};


.ut.type.const.infinites:raze (::;neg)@\:(0Wh;0Wi;0Wj;0We;0Wf;0Wp;0Wm;0Wd;0Wz;0Wn;0Wu;0Wv;0Wt);

/ Mapping of type name based on index in the list (matching .Q.t behaviour)
.ut.type.const.types:`mixedList`bool`guid``byte`short`int`long`real`float`char`sym`timestamp`month`date`datetime`timespan`minute`second`time;

/ Function string to use for all .ut.is* functions for higher performance
.ut.type.const.typeFunc:"{ --TYPE--~type x }";

/ Builds type checking functions .ut.is*Type* and .ut.is*Type*List from a string template function for highest performance
/  @param typeName (Symbol) The name of the type to build the functions for
/  @see .ut.const.types
.ut.type.i.setCheckFuncs:{[typeName]
    listType:`short$.ut.type.const.types?typeName;
    typeName:@[string typeName; 0; upper];

    atomName:`$"is",typeName;
    listName:`$"is",typeName,"List";

    set[` sv `.ut,atomName;] get ssr[.ut.type.const.typeFunc; "--TYPE--"; .Q.s1 neg listType];

    / If type 0, don't create the list version
    if[not listType = neg listType;
        set[` sv `.ut,listName;] get ssr[.ut.type.const.typeFunc; "--TYPE--"; .Q.s1 listType];
    ];
  };

.ut.type.init:{
    types:.ut.type.const.types where not null .ut.type.const.types;
    .ut.type.i.setCheckFuncs each types;
  };

.ut.isStr:{
    :10h~type x;
  };

.ut.isNumber:{
    :type[x] in -5 -6 -7 -8 -9h;
  };

.ut.isWholeNumber:{
    :type[x] in -5 -6 -7h;
  };

.ut.isDecimal:{
    :type[x] in -8 -9h;
  };

.ut.isDateOrTime:{
    :type[x] in -12 -13 -14 -15 -16 -17 -18 -19h;
  };

.ut.isFilePath:{
    :.ut.isSym[x] & ":"~first string x;
  };

.ut.isDict:.ut.isDictionary:{
    :99h~type x;
  };

.ut.isTable:.Q.qt;

.ut.isKeyed:{
    if[not .ut.isTable x;
        :0b;
    ];

    :0 < count keys x;
  };

// Supports checking a folder path without being loaded via system "l"
.ut.isSplayed:{
    if[.ut.isFilePath x;
        if[not .ut.isFolder x;
            :0b;
        ];

        if[not "/" = last string x;
            x:` sv x,`;
        ];
    ];

    :0b~.Q.qp $[.ut.isSym x;get;::] x;
  };

.ut.isParted:{
    :1b~.Q.qp $[.ut.isSym x;get;::] x;
  };

//  @returns (Boolean) If one or more columns in the table are enumerated
.ut.isEnumerated:{
    :any .ut.isEnum each .Q.V x;
  };

.ut.isFunction:{
    :type[x] in 100 101 102 103 104 105 106 107 108 109 110 111 112h;
  };

.ut.isEnum:{
    :type[x] within 20 76h;
  };

.ut.isAnymap:{
    :77h = type x;
  };

.ut.isInfinite:{
    :x in .ut.type.const.infinites;
  };

//  @return (Boolean) True if the input is a file reference and the file exists, false otherwise
.ut.isFile:{
    if[not .ut.isFilePath x; :0b];

    :x~key x;
  };

//  @returns (Boolean) True if the input is a folder reference, the reference exists on disk and the reference is a folder. False otherwise
.ut.isFolder:{
    if[not .ut.isFilePath x; :0b];

    :(not ()~key x) & not .ut.isFile x;
  };

.ut.isNamespace:{
    //:(~). 1#/:(.q;x);
    :(::) ~ first x;
  };

.ut.isEmptyNamespace:{
    //:x ~ 1#.q;
    :x ~ (::);
  };

.ut.isAtom:{
    :type[x] in -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19h;
  };

.ut.isList:{
  :type[x] in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96h;
  };

.ut.isTypedList:{
  :type[x] in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19h;
  };

.ut.isNestedList:{
  :type[x] in 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96h;
  };

.ut.isDistinct:{
  :x~distinct x;
  };

.ut.toSym:{
  if[.ut.isSym[x] | .ut.isSymList x; :x];

  :.ut.toStr[x];
  };

.ut.toStr:{
    :$[not .ut.isStr x; string;]x;
  };

.ut.toHsym:{
  :hsym .ut.toSym[x];
  };

.ut.type.init[];

