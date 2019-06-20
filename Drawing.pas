// Touch v1.0.0 by Tarek Al Ayoubi
// Known issues and planned updates:
// issue: rectangles erase under them
// issue: coordinates go off-screen
// issue: ruler is a joke
// issue: mouse ain't invisible when
//        drawing circuits
// planned: Arc drawing support
// planned: numpad to input dim.'s
// planned: smarter faster way to wire
// planned: nums instead of arrows for
//          for rotation??
// Dream: scrollable canvas
// Goal: drawing shapes interactively
// and generate the corresponding code
// to reuse in developing interactive
// apps and to save drawings for later
//*************************************
//Global variables
LOCAL r, g, c;
LOCAL m;
LOCAL z;
LOCAL s;
LOCAL l;
LOCAL sq, sqt;
LOCAL txts,tsize, tex;
LOCAL cr, crt;
LOCAL dir;
LOCAL ivs;
LOCAL dvs;
LOCAL ics;
LOCAL dcs;
LOCAL res;
LOCAL cap;
LOCAL ind;
LOCAL l1;
LOCAL l2;
LOCAL l3;
LOCAL l4;
LOCAL l0;
LOCAL w,b,gr;
EXPORT gcode;
EXPORT spixel;
//*************************************
//subroutines
UI();
ms(u,d,l,r);
cont();
bn();
bnc();
bui();
coor();
fh(t);
gs();
gsi();
bclear();
bdraw();
bsave();
lyn();
sqr(n);
txt();
tsat();
crc();
ccode();
tcode();
lcode();
fcode();
scode();
ce();
divs();
civs();
ddvs();
cdvs();
dics();
ddcs();
dres();
dcap();
dind();
bgcode();
psave();
hlp();
dbug();
//*************************************
//Main
EXPORT tp()
BEGIN
r:=1; g:=1; c:=1; //ui toggles
m:=1;             //mouse step
z:=1;             //power switch
s:=0;             //ink switch
l:=0;             //line switch
sq:=0;            //square switch
sqt:={};          //square tracker
txts:=0;          //text switch
tsize:=2;         //text size
tex:={""};        //text buffer
cr:=0;            //circle switch
crt:={};          //circle tracker
dir:=1;           //draw direction
ivs:=0;           //ind. voltage source
dvs:=0;           //dep. v. source
ics:=0;           //ind. current source
dcs:=0;           //dep. curr. source
res:=0;           //resistor switch
cap:=0;           //capacitor switch
ind:=0;           //inductor switch
l1:={};           //touch input
l2:={};           //line traker
l3:={0,0,0};      //ink tracker
l4:={};           //code stack
l0:={159,109};    //mouse location
spixel:={};       //pixels are saved
w:=RGB(255,255,255);b:=RGB(0,0,0);
gr:=RGB(128,128,128);
gsi();
UI;
WHILE z DO
cont;
END;
gcode:=l4;
RETURN "Generated "+SIZE(gcode)+
" lines   "+"By Tarek © 2017-2018";
END;//of main
//*************************************
UI()
BEGIN
LOCAL x,y;
RECT(b);
//Ruler
IF r THEN
LINE_P(0,0,318,0,w);
LINE_P(0,0,0,218,w);
END;
//Grid
IF g THEN
FOR x FROM 0 TO 318 STEP 10 DO
FOR y FROM 0 TO 218 STEP 10 DO
LINE_P(x,y,x,y,gr);
END; END; END;
DRAWMENU("UI","Circuit","Draw",
         "Save","Mouse","Clear");
SUBGROB_P(G0,G1);
gs;
ms(0,0,0,0);
END;
//*************************************
ms(u,d,l,r)
BEGIN
LOCAL x := l0(1) , y := l0(2);
gs(); // Animate
//Horizontal Line
LINE_P(x-5+r-l,y-u+d,x+5+r-l,y-u+d,w);
//Vertical Line
LINE_P(x+r-l,y-5-u+d,x+r-l,y+5-u+d,w);
//Point
LINE_P(x+r-l,y-u+d,x+r-l,y-u+d,b);
//Update Location
l0 := {x+r-l,y-u+d};
//Saturation Check
IF l0(1)>318 THEN //Right Edge
l0(1):=318; ms(0,0,0,0); END;
IF l0(2)>218 THEN //Lower Edge 
l0(2):=218; ms(0,0,0,0) END;
IF l0(1)<0 THEN //Left Edge
l0(1):=0; ms(0,0,0,0) END;
IF l0(2)<0 THEN //Upper Edge
l0(2):=0; ms(0,0,0,0) END;
END;
//*************************************
cont()
BEGIN
LOCAL k := 0;
l1:= WAIT(-1);
IF SIZE(l1)==1 THEN l1:={l1}; END;
// Was any key pressed?
IF ISKEYDOWN(2) OR
   ISKEYDOWN(12) OR
   ISKEYDOWN(7) OR
   ISKEYDOWN(8) OR
   ISKEYDOWN(4) OR
   ISKEYDOWN(30) OR
   ISKEYDOWN(45) OR
   ISKEYDOWN(50) OR
   ISKEYDOWN(3)
THEN
k:=1;
END;
//Keyboard
IF SIZE(l1)==1 AND k THEN
CASE
IF l1(1)==2  THEN ms(m,0,0,0); dir:=1;
END;
IF l1(1)==12 THEN ms(0,m,0,0); dir:=2;
END;
IF l1(1)==7  THEN ms(0,0,m,0); dir:=3;
END;
IF l1(1)==8  THEN ms(0,0,0,m); dir:=4;
END;
IF l1(1)==4  THEN z:=0 END;
IF l1(1)==45 THEN
IF txts THEN tsat(-1); END; END;
IF l1(1)==50 THEN
IF txts THEN tsat(1); END; END;
IF l1(1)==3 THEN hlp; END;
IF l1(1)==30 THEN 
IF l THEN lyn(3); END;
IF sq THEN sqr(3); END;
IF cr THEN crc(3); END;
IF txts THEN txt(3); END;
IF ivs THEN divs(2); END;
IF dvs THEN ddvs(2); END;
IF ics THEN dics(2); END;
IF dcs THEN ddcs(2); END;
IF res THEN dres(2); END;
IF cap THEN dcap(2); END;
IF ind THEN dind(2); END;
IF s THEN fh(1); END;
END;// of last case if
END;//of case
END;//of if of k
ms(0,0,0,0);

//Touch mouse controller
IF SIZE(l1)==3 THEN
IF l1(3)≤218 THEN
l0(1):= l1(2);
l0(2):= l1(3);
ms(0,0,0,0);
END;
// Any Key touched?
IF l1(1)==3 THEN
bn({l1(2),l1(3)}); END;
END;
// interactive tools (in animation)
//dbug();
IF c THEN coor(); END;
fh(0);
IF l THEN lyn(2); END;
IF sq THEN sqr(2); END;
IF cr THEN crc(2); END;
IF txts THEN txt(2); END;
IF ivs THEN divs(1); END;
IF dvs THEN ddvs(1); END;
IF ics THEN dics(1); END;
IF dcs THEN ddcs(1); END;
IF res THEN dres(1); END;
IF cap THEN dcap(1); END;
IF ind THEN dind(1); END;
END;//of cont
//*************************************
bn(t) // Buttons functionalities
BEGIN
t := bnc(t);
CASE
IF t==1 THEN bui(); END;
IF t==2 THEN ce; END;
IF t==3 THEN bdraw(); END;
IF t==4 THEN bsave(); END;
IF t==5 THEN INPUT(m);gs; END;
IF t==6 THEN bclear; END;
END;

END;
//*************************************
bnc(t) // Buttons touch enabler
BEGIN
LOCAL tx:=t(1) , ty:= t(2);
LOCAL bw:=53, bh:=20;

LOCAL b1:={0,220};
LOCAL b2:={54,220};
LOCAL b3:={106,220};
LOCAl b4:={159,220};
LOCAl b5:={212,220};
LOCAL b6:={265,220};

LOCAL b1xi:= b1(1), b1xf:= b1(1)+bw;
LOCAL b1yi:= b1(2), b1yf:= b1(2)+bh;

LOCAL b2xi:= b2(1), b2xf:= b2(1)+bw;
LOCAL b2yi:= b2(2), b2yf:= b2(2)+bh;

LOCAL b3xi:= b3(1), b3xf:= b3(1)+bw;
LOCAL b3yi:= b3(2), b3yf:= b3(2)+bh;

LOCAL b4xi:= b4(1), b4xf:= b4(1)+bw;
LOCAL b4yi:= b4(2), b4yf:= b4(2)+bh;

LOCAL b5xi:= b5(1), b5xf:= b5(1)+bw;
LOCAL b5yi:= b5(2), b5yf:= b5(2)+bh;

LOCAL b6xi:= b6(1), b6xf:= b6(1)+bw;
LOCAL b6yi:= b6(2), b6yf:= b6(2)+bh;

CASE
IF ((tx≥b1xi)AND(tx≤b1xf)) AND
   ((ty≥b1yi)AND(ty≤b1yf)) THEN
RETURN 1;
END;

IF ((tx≥b2xi)AND(tx≤b2xf)) AND
   ((ty≥b2yi)AND(ty≤b2yf)) THEN
RETURN 2;
END;

IF ((tx≥b3xi)AND(tx≤b3xf)) AND
   ((ty≥b3yi)AND(ty≤b3yf)) THEN
RETURN 3;
END;

IF ((tx≥b4xi)AND(tx≤b4xf)) AND
   ((ty≥b4yi)AND(ty≤b4yf)) THEN
RETURN 4;
END;

IF ((tx≥b5xi)AND(tx≤b5xf)) AND
   ((ty≥b5yi)AND(ty≤b5yf)) THEN  
RETURN 5;
END;

IF ((tx≥b6xi)AND(tx≤b6xf)) AND
   ((ty≥b6yi)AND(ty≤b6yf)) THEN  
RETURN 6;
END;//of last if

END;//of case

END;//of bnc
//*************************************
bui() //UI button function
BEGIN
IF g>1 THEN g:=1; END;
IF r>1 THEN r:=1; END;
IF c>1 THEN c:=1; END;

LOCAL o;
LOCAL options:= {"Ruler","Grid",
                  "Coordinates"};
CHOOSE(o,"UI Options",options);
CASE
IF o==1 THEN r:=NOT r END;
IF o==2 THEN g:=NOT g END;
IF o==3 THEN c:=NOT c END;
END;
UI();
END;
//*************************************
bclear() BEGIN
RECT(G2,b);
gs;
ms(0,0,0,0);
l4:={};
END;
//*************************************
bsave() BEGIN
LOCAL op, options;
options:={"Generate Code",
           "Save Pixels"};
CHOOSE(op,"Choose saving method",
       options);gs;
CASE
IF op==1 THEN bgcode(); END;
IF op==2 THEN psave(); END;
END;
END;
//*************************************
//Coordinates
coor() BEGIN
LOCAL x:= l0(1), y:= l0(2);
LOCAL xi:= l0(1) - 6;
LOCAL yi:= l0(2) - 6;
LOCAL ty:=yi/2, tx:=xi/2;
LINE_P(xi,y,0,y,gr);
LINE_P(x,yi,x,0,gr);
TEXTOUT_P(x,x+2,ty,1,w);
TEXTOUT_P(y,tx,y+3,1,w); 
END;
//*************************************
//free hand writing ink button
fh(t) BEGIN
// t = 1 turn off/on the switch
// t = 0 do not touch the switch
// s the switch

IF t==1 THEN s:= NOT s; l3(3):=1; END;
IF s==1 THEN
LINE_P(G2,l0(1),l0(2),l0(1),l0(2),w);
fcode(1);
IF l3(3)==0 THEN
LINE_P(G2,l3(1),l3(2),l0(1),l0(2),w);
fcode(2);
END;
END;
l3:={l0(1),l0(2),0};
END;
//*************************************
bdraw() BEGIN
LOCAL options := {"Line","Rectangle",
                   "Circle","Text",
                   "Free Hand"};
LOCAL op;
op:= CHOOSE(op,"Draw",options);gs;
CASE
IF op==1 THEN lyn(1); END;
IF op==2 THEN sqr(1); END;
IF op==3 THEN crc(1); END;
IF op==4 THEN txt(1); END;
IF op==5 THEN fh(1); END;
END;//of case
END;//of bdraw
//*************************************
lyn(n) BEGIN
CASE
IF n==1 THEN
LINE_P(G2,l0(1),l0(2),l0(1),l0(2),w);
l2:=l0;
l:=1;
END;
IF n==2 THEN
LINE_P(l2(1),l2(2),l0(1),l0(2),w); 
END;
IF n==3 THEN
l:=0;
LINE_P(G2,l2(1),l2(2),l0(1),l0(2),w); 
lcode();
END;
END;//of case
END;
//*************************************
sqr(n) BEGIN
CASE
IF n==1 THEN sq:=1; sqt:=l0; END;
IF n==2 THEN
RECT_P(sqt(1),sqt(2),l0(1),l0(2),
RGB(255,255,255),RGB(0,0,0));
END;
IF n==3 THEN
sq:=0;
RECT_P(G2,sqt(1),sqt(2),l0(1),l0(2),
RGB(255,255,255),RGB(0,0,0));
scode;
END;
END;//of case
END;//of sqr
//*************************************
txt(n) BEGIN
CASE
IF n==1 THEN
txts:=1;
EDITLIST(tex);gs;
END;
IF n==2 THEN
TEXTOUT_P(tex(1),l0(1),l0(2),tsize,w);
END;
IF n==3 THEN
TEXTOUT_P(tex(1),G2,l0(1),l0(2),
          tsize,w);
tcode;
txts:=0;
END;
END;//of case
END;//of txt
//*************************************
tsat(n) BEGIN
tsize:= tsize +n;
IF tsize > 7 THEN tsize:=7; END;
IF tsize < 1 THEN tsize:=1; END;
END;
//*************************************
tcode() BEGIN
LOCAL s ,s1, s2, t:=STRING(tex(1));
s1:="TEXTOUT_P(";
s2:=","+l0(1)+","+l0(2)+","+
    tsize+");";
s:=s1+t+s2;
l4(SIZE(l4)+1):=s;
END;
//*************************************
crc(n) BEGIN
CASE
IF n==1 THEN
cr:=1;
crt:=l0;
END;
IF n==2 THEN
ARC_P(crt(1),crt(2),
      sqrt((l0(1)-crt(1))^2+
           (l0(2)-crt(2))^2),w);
END;
IF n==3 THEN
ARC_P(G2,crt(1),crt(2),
      sqrt((l0(1)-crt(1))^2+
           (l0(2)-crt(2))^2),w);
ccode;
cr:=0;
END;
END;//of case
END;//of crc
//*************************************
ccode() BEGIN
LOCAL s;
s:=STRING("ARC_P("+crt(1)+","+crt(2)+
          ","+sqrt((l0(1)-crt(1))^2+
          (l0(2)-crt(2))^2)+");");
s:=MID(s,2,DIM(s)-2);
l4(SIZE(l4)+1):=s;
END;
//*************************************
lcode() BEGIN
LOCAL s;
s:=STRING("LINE_P("+l2(1)+","+l2(2)+
          ","+l0(1)+","+l0(2)+");");
s:=MID(s,2,DIM(s)-2);
l4(SIZE(l4)+1):=s;
END;
//*************************************
fcode(n) BEGIN
LOCAL s;
CASE
IF n==1 THEN
s:= STRING("LINE_P("+l0(1)+","+l0(2)+
           ","+l0(1)+","+l0(2)+");");
s:= MID(s,2,DIM(s)-2);
l4(SIZE(l4)+1):=s; 
END;//of n==1
IF n==2 THEN
s:= STRING("LINE_P("+l3(1)+","+l3(2)+
           ","+l0(1)+","+l0(2)+");");
s:= MID(s,2,DIM(s)-2);
l4(SIZE(l4)+1):=s;
END;//of n==2
END;//of case
END;//of fcode
//*************************************
scode() BEGIN
LOCAL s;
s:=STRING("RECT_P("+sqt(1)+","+sqt(2)+
          ","+l0(1)+","+l0(2)+","+
     "RGB(255,255,255),RGB(0,0,0));");
s:=MID(s,2,DIM(s)-2);
l4(SIZE(l4)+1):=s;
END;
//*************************************
ce() BEGIN
LOCAL op, options;
options:={"Independent Voltage Source"
         ,"Dependent Voltage Source"
         ,"Independent Current Source"
         ,"Dependent Current Source"
         ,"Resistor"
         ,"Capacitor"
         ,"Inductors"
};
CHOOSE(op,"Circuit Elements",options);
gs;
CASE
IF op==1 THEN divs(1); END;
IF op==2 THEN ddvs(1); END;
IF op==3 THEN dics(1); END;
IF op==4 THEN ddcs(1); END;
IF op==5 THEN dres(1); END;
IF op==6 THEN dcap(1); END;
IF op==7 THEN dind(1); END;
END;

END;
//*************************************
divs(n) BEGIN
LOCAL hi,vi, hf, vf, px, nx, py, ny;
CASE //terminal direction
IF dir==1 OR dir==2 THEN
hi:=0; hf:=0; vi:=8; vf:=18; END;
IF dir==3 OR dir==4 THEN
hi:=8; hf:=18; vi:=0; vf:=0; END;
END;
CASE //sign direction
IF dir==1 THEN
px:=-3; nx:=-3; py:=-8; ny:=-1; END;
IF dir==2 THEN 
px:=-3; nx:=-3; py:=-1; ny:=-8; END;
IF dir==3 THEN
px:=-6; nx:=1; py:=-5; ny:=-5; END;
IF dir==4 THEN
px:=1; nx:=-6; py:=-5; ny:=-5; END;
END;
CASE//drawing phases
IF n==1 THEN
ivs:=1;
ARC_P(l0(1),l0(2),8,w);
LINE_P(l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
TEXTOUT_P("+",l0(1)+px,l0(2)+py,2,w);
TEXTOUT_P("-",l0(1)+nx,l0(2)+ny,2,w);
END;//of n==1
IF n==2 THEN
ARC_P(G2,l0(1),l0(2),8,w);
LINE_P(G2,l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(G2,l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
TEXTOUT_P("+",G2,l0(1)+px,l0(2)+py,
2,w);
TEXTOUT_P("-",G2,l0(1)+nx,l0(2)+ny,
2,w);
//civs(hi,vi,hf,vf,px,nx,py,ny);
ivs:=0;
END;//of n==2
END;//of case
END;//of divs
//*************************************
civs(hi,vi,hf,vf,px,nx,py,ny) BEGIN
LOCAL s,p:=STRING("+"),n:=STRING("-");
s:= "ARC_P("+l0(1)+","+l0(2)+",8);";
l4(SIZE(l4)+1):=s;
s:="LINE_P("+(l0(1)-hi)+","+(l0(2)-vi)
+","+(l0(1)-hf)+","+(l0(2)-vf)+");";
l4(SIZE(l4)+1):=s;
s:="LINE_P("+(l0(1)+hi)+","+(l0(2)+vi)
+","+(l0(1)+hf)+","+(l0(2)+vf)+");";
l4(SIZE(l4)+1):=s;
s:="TEXTOUT_P("+p+","+(l0(1)+px)+","+
           (l0(2)+py)+",2);";
l4(SIZE(l4)+1):=s;
s:="TEXTOUT_P("+n+","+(l0(1)+nx)+","+
    (l0(2)+ny)+",2);";
l4(SIZE(l4)+1):=s;
END;
//*************************************
ddvs(n) BEGIN
LOCAL hi,vi, hf, vf, px, nx, py, ny;
CASE //terminal direction
IF dir==1 OR dir==2 THEN
hi:=0; hf:=0; vi:=8; vf:=18; END;
IF dir==3 OR dir==4 THEN
hi:=8; hf:=18; vi:=0; vf:=0; END;
END;
CASE //sign direction
IF dir==1 THEN
px:=-3; nx:=-3; py:=-8; ny:=-1; END;
IF dir==2 THEN 
px:=-3; nx:=-3; py:=-1; ny:=-8; END;
IF dir==3 THEN
px:=-6; nx:=1; py:=-5; ny:=-5; END;
IF dir==4 THEN
px:=1; nx:=-6; py:=-5; ny:=-5; END;
END;
CASE//drawing phases
IF n==1 THEN
dvs:=1;
LINE_P(l0(1),l0(2)-8,l0(1)+8,l0(2),w);
LINE_P(l0(1),l0(2)-8,l0(1)-8,l0(2),w);
LINE_P(l0(1),l0(2)+8,l0(1)+8,l0(2),w);
LINE_P(l0(1),l0(2)+8,l0(1)-8,l0(2),w);
LINE_P(l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
TEXTOUT_P("+",l0(1)+px,l0(2)+py,2,w);
TEXTOUT_P("-",l0(1)+nx,l0(2)+ny,2,w);
END;//of n==1
IF n==2 THEN
LINE_P(G2,l0(1),l0(2)-8,l0(1)+8,l0(2)
,w);
LINE_P(G2,l0(1),l0(2)-8,l0(1)-8,l0(2)
,w);
LINE_P(G2,l0(1),l0(2)+8,l0(1)+8,l0(2)
,w);
LINE_P(G2,l0(1),l0(2)+8,l0(1)-8,l0(2)
,w);
LINE_P(G2,l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(G2,l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
TEXTOUT_P("+",G2,l0(1)+px,l0(2)+py,
2,w);
TEXTOUT_P("-",G2,l0(1)+nx,l0(2)+ny,
2,w);
dvs:=0;
END;//of n==2
END;//of case
END;
//*************************************
dics(n) BEGIN
LOCAL hi,vi, hf, vf, px, nx, py, ny;
CASE //terminal direction
IF dir==1 OR dir==2 THEN
hi:=0; hf:=0; vi:=8; vf:=18; END;
IF dir==3 OR dir==4 THEN
hi:=8; hf:=18; vi:=0; vf:=0; END;
END;
CASE//drawing phases
IF n==1 THEN
ics:=1;
ARC_P(l0(1),l0(2),8,w);
LINE_P(l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
//arrow
IF dir==1 THEN
TEXTOUT_P("↑",l0(1)-2,l0(2)-5,1,w);END;
IF dir==2 THEN
TEXTOUT_P("↓",l0(1)-2,l0(2)-5,1,w);END;
IF dir==3 THEN
TEXTOUT_P("←",l0(1)-5,l0(2)-5,1,w);
END;
IF dir==4 THEN
TEXTOUT_P("→",l0(1)-5,l0(2)-5,1,w);
END;
END;//of n==1
IF n==2 THEN
ARC_P(G2,l0(1),l0(2),8,w);
LINE_P(G2,l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(G2,l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
//arrow
IF dir==1 THEN
TEXTOUT_P("↑",G2,l0(1)-2,l0(2)-5,1,w);
END;
IF dir==2 THEN
TEXTOUT_P("↓",G2,l0(1)-2,l0(2)-5,1,w);
END;
IF dir==3 THEN
TEXTOUT_P("←",G2,l0(1)-5,l0(2)-5,1,w);
END;
IF dir==4 THEN
TEXTOUT_P("→",G2,l0(1)-5,l0(2)-5,1,w);
END;
ics:=0;
END;//of n==2
END;//of case
END;//of dics
//*************************************
ddcs(n) BEGIN
LOCAL hi,vi, hf, vf, px, nx, py, ny;
CASE //terminal direction
IF dir==1 OR dir==2 THEN
hi:=0; hf:=0; vi:=8; vf:=18; END;
IF dir==3 OR dir==4 THEN
hi:=8; hf:=18; vi:=0; vf:=0; END;
END;
CASE//drawing phases
IF n==1 THEN
dcs:=1;
LINE_P(l0(1),l0(2)-8,l0(1)+8,l0(2),w);
LINE_P(l0(1),l0(2)-8,l0(1)-8,l0(2),w);
LINE_P(l0(1),l0(2)+8,l0(1)+8,l0(2),w);
LINE_P(l0(1),l0(2)+8,l0(1)-8,l0(2),w);
LINE_P(l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
//arrow
IF dir==1 THEN
TEXTOUT_P("↑",l0(1)-2,l0(2)-5,1,w);END;
IF dir==2 THEN
TEXTOUT_P("↓",l0(1)-2,l0(2)-5,1,w);END;
IF dir==3 THEN
TEXTOUT_P("←",l0(1)-5,l0(2)-5,1,w);
END;
IF dir==4 THEN
TEXTOUT_P("→",l0(1)-5,l0(2)-5,1,w);
END;
END;//of n==1
IF n==2 THEN
LINE_P(G2,l0(1),l0(2)-8,l0(1)+8,l0(2)
,w);
LINE_P(G2,l0(1),l0(2)-8,l0(1)-8,l0(2)
,w);
LINE_P(G2,l0(1),l0(2)+8,l0(1)+8,l0(2)
,w);
LINE_P(G2,l0(1),l0(2)+8,l0(1)-8,l0(2)
,w);
LINE_P(G2,l0(1)-hi,l0(2)-vi,
       l0(1)-hf,l0(2)-vf,w);
LINE_P(G2,l0(1)+hi,l0(2)+vi,
       l0(1)+hf,l0(2)+vf,w);
//arrow
IF dir==1 THEN
TEXTOUT_P("↑",G2,l0(1)-2,l0(2)-5,1,w);
END;
IF dir==2 THEN
TEXTOUT_P("↓",G2,l0(1)-2,l0(2)-5,1,w);
END;
IF dir==3 THEN
TEXTOUT_P("←",G2,l0(1)-5,l0(2)-5,1,w);
END;
IF dir==4 THEN
TEXTOUT_P("→",G2,l0(1)-5,l0(2)-5,1,w);
END;
dcs:=0;
END;//of n==2
END;//of case
END;
//*************************************
dres(n) BEGIN
LOCAL h,hf,hs,h5,ha;
LOCAL v,vf,vs,v5,va;
CASE//direcion
IF dir==1 THEN
h:=0;hf:=-1;hs:=0;h5:=0;ha:=0;
v:=-10;vf:=-40;vs:=-10;v5:=-5;va:=-10;
END;
IF dir==2 THEN
h:=0;hf:=-1;hs:=0;h5:=0;ha:=0;
v:=10;vf:=40;vs:=10;v5:=5;va:=10;
END;
IF dir==3 THEN 
h:=-10;hf:=-40;hs:=-10;h5:=-5;ha:=-10;
v:=0;vf:=-1;vs:=0;v5:=0;va:=0;
END;
IF dir==4 THEN 
h:=10;hf:=40;hs:=10;h5:=5;ha:=10;
v:=0;vf:=-1;vs:=0;v5:=0;va:=0;
END;
END;//of case
CASE//phase
IF n==1 THEN
res:=1;
LINE_P(l0(1),l0(2),l0(1)+h,l0(2)+v,w);
WHILE h≠hf AND v≠vf DO
LINE_P(l0(1)+h,l0(2)+v,
       l0(1)+h+h5+v5,l0(2)-h5+v+v5,w);
LINE_P(l0(1)+h+h5+v5,l0(2)-h5+v+v5,
        l0(1)+h+ha,l0(2)+v+va,w);
h:=h+hs;v:=v+vs;END;         //of while
LINE_P(l0(1)+h,l0(2)+v,
       l0(1)+h+ha,l0(2)+v+va,w);
END;//of n==1
IF n==2 THEN
LINE_P(G2,l0(1),l0(2),
           l0(1)+h,l0(2)+v,w);
WHILE h≠hf AND v≠vf DO
LINE_P(G2,l0(1)+h,l0(2)+v,
       l0(1)+h+h5+v5,l0(2)-h5+v+v5,w);
LINE_P(G2,l0(1)+h+h5+v5,l0(2)-h5+v+v5,
        l0(1)+h+ha,l0(2)+v+va,w);
h:=h+hs;v:=v+vs;END;         //of while
LINE_P(G2,l0(1)+h,l0(2)+v,
       l0(1)+h+ha,l0(2)+v+va,w);
res:=0;
END;//of n==2
END;//of case
END;//of dres
//*************************************
dcap(n) BEGIN
LOCAL x:=l0(1), y:=l0(2);
CASE
IF n==1 THEN
cap:=1;
IF dir==1 OR dir==2 THEN
LINE_P(x-9,y-9,x-9,y+11,w);
LINE_P(x+11,y-9,x+11,y+11,w);
LINE_P(x-9,y+1,x-19,y+1,w);
LINE_P(x+11,y+1,x+21,y+1,w);
END;
IF dir==3 OR dir==4 THEN
LINE_P(x-9,y-9,x+11,y-9,w);
LINE_P(x-9,y+11,x+11,y+11,w);
LINE_P(x+1,y-9,x+1,y-19,w);
LINE_P(x+1,y+11,x+1,y+21,w);
END;
END;//of n==1
IF n==2 THEN
IF dir==1 OR dir==2 THEN
LINE_P(G2,x-9,y-9,x-9,y+11,w);
LINE_P(G2,x+11,y-9,x+11,y+11,w);
LINE_P(G2,x-9,y+1,x-19,y+1,w);
LINE_P(G2,x+11,y+1,x+21,y+1,w);
END;
IF dir==3 OR dir==4 THEN
LINE_P(G2,x-9,y-9,x+11,y-9,w);
LINE_P(G2,x-9,y+11,x+11,y+11,w);
LINE_P(G2,x+1,y-9,x+1,y-19,w);
LINE_P(G2,x+1,y+11,x+1,y+21,w);
END;
cap:=0;
END;//of n==2
END;//of case
END;//of dcap
//*************************************
dind(n) BEGIN
LOCAL x:=l0(1), y:=l0(2), d:=-20;
CASE
IF n==1 THEN
ind:=1;
IF dir==3 OR dir==4 THEN
LINE_P(x-21,y+1,x-31,y+1,w);
WHILE d<20 DO
LINE_P(x+1+d,y+1,x+4+d,y-4,w);
LINE_P(x+4+d,y-4,x+8+d,y-4,w);
LINE_P(x+8+d,y-4,x+11+d,y+1,w);
d:=d+10;
END;
LINE_P(x+21,y+1,x+31,y+1,w);
END;//of 3 or 4
IF dir==1 OR dir==2 THEN
LINE_P(x+1,y-21,x+1,y-31,w);
WHILE d<20 DO
LINE_P(x+1,y+1+d,x-4,y+4+d,w);
LINE_P(x-4,y+4+d,x-4,y+8+d,w);
LINE_P(x-4,y+8+d,x+1,y+11+d,w);
d:=d+10;
END;
LINE_P(x+1,y+21,x+1,y+31,w);
END;//of 1 or 2
END;//of n==1
IF n==2 THEN
IF dir==3 OR dir==4 THEN
LINE_P(G2,x-21,y+1,x-31,y+1,w);
WHILE d<20 DO
LINE_P(G2,x+1+d,y+1,x+4+d,y-4,w);
LINE_P(G2,x+4+d,y-4,x+8+d,y-4,w);
LINE_P(G2,x+8+d,y-4,x+11+d,y+1,w);
d:=d+10;
END;
LINE_P(G2,x+21,y+1,x+31,y+1,w);
END;//of 3 or 4
IF dir==1 OR dir==2 THEN
LINE_P(G2,x+1,y-21,x+1,y-31,w);
WHILE d<20 DO
LINE_P(G2,x+1,y+1+d,x-4,y+4+d,w);
LINE_P(G2,x-4,y+4+d,x-4,y+8+d,w);
LINE_P(G2,x-4,y+8+d,x+1,y+11+d,w);
d:=d+10;
END;
LINE_P(G2,x+1,y+21,x+1,y+31);
END;//of 1 or 2
ind:=0;
END;//of n==2
END;//of case
END;//of dind
//*************************************
bgcode() BEGIN
LOCAL i;
PRINT();
FOR i FROM 1 TO SIZE(l4) STEP 1 DO
PRINT(l4(i));
END;
z:=0;
END;
//*************************************
//graphics manager
gs() BEGIN
BLIT_P(G1);
BLIT_P(G2,b);
END;
//*************************************
//graphics intializer
gsi() BEGIN
SUBGROB_P(G0,G1);
SUBGROB_P(G0,G2);
RECT(G1);
RECT(G2,b);
END;
//*************************************
//Pixel Save
psave() BEGIN 
LOCAL i,j;
LOCAL h:=GROBH_P(G0),w:=GROBW_P(G0);
FOR i FROM 0 TO w DO
FOR j FROM 0 TO h DO
spixel(i,j):=GETPIX_P(G2,i,j);
END;END;//of fors
z:=0;
END;
//*************************************
rpixel()
BEGIN
LOCAL i,j;
LOCAL w:=GROBW_P(G0),h:=GROBH_P(G0);
FOR i FROM 0 TO w DO
FOR j FROM 0 TO h DO
PIXON_P(i,j,spixel(i,j));
END;END;
WAIT;
END;
//*************************************
hlp() BEGIN
RECT();
TEXTOUT_P("Instructions:",0,0,2);
TEXTOUT_P("*UI: includes settings to toggle UI settings.",0,20,2);
TEXTOUT_P("*Circuit: draw circuit elements by doing the following:",0,40,2);
TEXTOUT_P("Choose the element and use touch or arrows to move it.",0,60,2);
TEXTOUT_P("Arrows also change rotation. Then hit enter to draw it.",0,80,2);
TEXTOUT_P("*Draw: locate the mouse where you want to start drawing",0,100,2);
TEXTOUT_P("Line: move the mouse to position 2nd point. Enter to draw",0,120,2);
TEXTOUT_P("Rectangle: it's unrecommended to use it in this version",0,140,2);
TEXTOUT_P("Circle: use mouse to adjust radius. Enter to draw.",0,160,2);
TEXTOUT_P("Text: hit 'edit' and enter text in quoutes. 'ok' twice to draw",0,180,2);
TEXTOUT_P("Free Hand: draw with touch and arrows. Enter to toggle.",0,200,2);
TEXTOUT_P("*Save: 1:saves code in 'gcode'|2:saves pixels in 'spixel'",0,220,2);
TEXTOUT_P("*Mouse: adjust mouse step when using arrows",0,240,2);
WAIT;
gs(); ms(0,0,0,0);
END;
//*************************************
// End of Touch
//*************************************
dbug() BEGIN
IF SIZE(l1)==1 THEN
TEXTOUT_P("Input Type="+l1(1),5,180);
END;
IF SIZE(l1)==3 THEN
TEXTOUT_P("Input Type="+l1(1),5,180);
TEXTOUT_P("x="+l1(2)+" "+"y="+l1(3)
,5,200);END;
TEXTOUT_P("x="+l0(1)+" "+"y="+l0(2)
,235,200);
END;
//*************************************
