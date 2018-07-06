Convert all numeric missings for all columns to zero

Same result in WPS and SAS. Diff random realizations made datasets different.

Note using  "options missing='0'" does note remove the missing datatype.
Procedures like 'proc means' will exclude these missings, but not the
zeros created below.


https://tinyurl.com/ycac3lqv
https://communities.sas.com/t5/SAS-Tips-from-the-Community/SAS-Tip-Convert-MISSING-to-0/m-p/476013

Inspired by K Sharp
https://communities.sas.com/t5/user/viewprofilepage/user-id/18408


INPUT
=====

 WORK.HAVE total obs=10

    NAME       SEX    AGE    HEIGHT    WEIGHT

    Alfred      M      14       .       112.5
    Alice       F      13     56.5         .
    Barbara     F      13     65.3         .
    Carol       F       .     62.8         .
    Henry       M       .     63.5         .
    James       M      12       .        83.0
    Jane        F      12       .        84.5
    Janet       F      15       .       112.5
    Jeffrey     M      13     62.5       84.0
    John        M      12       .          .


EXAMPLE OUTPUT
--------------

  WORK.WANT total obs=10

    NAME       SEX    AGE    HEIGHT    WEIGHT

    Alfred      M      14      0.0      112.5
    Alice       F      13     56.5        0.0
    Barbara     F      13     65.3        0.0
    Carol       F       0     62.8        0.0
    Henry       M       0     63.5        0.0
    James       M      12      0.0       83.0
    Jane        F      12      0.0       84.5
    Janet       F      15      0.0      112.5
    Jeffrey     M      13     62.5       84.0
    John        M      12      0.0        0.0


PROCESS
=======

proc stdize data=have out=want missing=0 reponly;
run;quit;


OUTPUT
======

  WORK.WANT total obs=10

    NAME       SEX    AGE    HEIGHT    WEIGHT

    Alfred      M      14      0.0      112.5
    Alice       F      13     56.5        0.0
    Barbara     F      13     65.3        0.0
    Carol       F       0     62.8        0.0
    Henry       M       0     63.5        0.0
    James       M      12      0.0       83.0
    Jane        F      12      0.0       84.5
    Janet       F      15      0.0      112.5
    Jeffrey     M      13     62.5       84.0
    John        M      12      0.0        0.0

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


options missing=.;
data have;
 set sashelp.class(obs=10);
 array nums _numeric_;
 do over nums;
   if uniform(12234)<.45 then nums=.;
 end;
run;quit;


*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

* SAS sep process;

* WPS;
%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc stdize data=wrk.have out=want missing=0 reponly;
run;quit;
proc print;
run;quit;
');

