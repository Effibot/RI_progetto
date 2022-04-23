<TeXmacs|2.1.1>

<style|<tuple|generic|italian|maxima>>

<\body>
  <\session|maxima|default>
    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>1) >
    <|unfolded-io>
      derivabbrev:true
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o1>)
      >><math-bf|true>>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>10) >
    <|input>
      \;
    </input>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>2) >
    <|unfolded-io>
      depends([x,y,u,l],t)
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o2>)
      >><around*|[|x<around*|(|t|)>,y<around*|(|t|)>,u<around*|(|t|)>,l<around*|(|t|)>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>3) >
    <|unfolded-io>
      lambda:matrix([l[1]],[l[2]],[l[3]],[l[4]])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o3>)
      >><matrix|<tformat|<table|<row|<cell|l<rsub|1>>>|<row|<cell|l<rsub|2>>>|<row|<cell|l<rsub|3>>>|<row|<cell|l<rsub|4>>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>4) >
    <|unfolded-io>
      diff(lambda[1,1],t)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o4>)
      >><around*|(|l<rsub|1>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>5) >
    <|unfolded-io>
      z:matrix([x[1]],[x[2]],[y[1]],[y[2]],[u[1]],[u[2]])
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o5>)
      >><matrix|<tformat|<table|<row|<cell|x<rsub|1>>>|<row|<cell|x<rsub|2>>>|<row|<cell|y<rsub|1>>>|<row|<cell|y<rsub|2>>>|<row|<cell|u<rsub|1>>>|<row|<cell|u<rsub|2>>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>6) >
    <|unfolded-io>
      zdot:diff(z,t)
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o6>)
      >><matrix|<tformat|<table|<row|<cell|<around*|(|x<rsub|1>|)><rsub|t>>>|<row|<cell|<around*|(|x<rsub|2>|)><rsub|t>>>|<row|<cell|<around*|(|y<rsub|1>|)><rsub|t>>>|<row|<cell|<around*|(|y<rsub|2>|)><rsub|t>>>|<row|<cell|<around*|(|u<rsub|1>|)><rsub|t>>>|<row|<cell|<around*|(|u<rsub|2>|)><rsub|t>>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>7) >
    <|unfolded-io>
      state:matrix([zdot[1,1]-z[2,1]],[zdot[2,1]-z[5,1]],

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ [zdot[3,1]-z[4,1]],[zdot[4,1]-z[6,1]])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o7>)
      >><matrix|<tformat|<table|<row|<cell|<around*|(|x<rsub|1>|)><rsub|t>-x<rsub|2>>>|<row|<cell|<around*|(|x<rsub|2>|)><rsub|t>-u<rsub|1>>>|<row|<cell|<around*|(|y<rsub|1>|)><rsub|t>-y<rsub|2>>>|<row|<cell|<around*|(|y<rsub|2>|)><rsub|t>-u<rsub|2>>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>8) >
    <|unfolded-io>
      L:1
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o8>)
      >>1>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>9) >
    <|unfolded-io>
      Le:L+transpose(lambda).state
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o9>)
      >>l<rsub|4>*<around*|(|<around*|(|y<rsub|2>|)><rsub|t>-u<rsub|2>|)>+l<rsub|2>*<around*|(|<around*|(|x<rsub|2>|)><rsub|t>-u<rsub|1>|)>+l<rsub|3>*<around*|(|<around*|(|y<rsub|1>|)><rsub|t>-y<rsub|2>|)>+l<rsub|1>*<around*|(|<around*|(|x<rsub|1>|)><rsub|t>-x<rsub|2>|)>+1>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>10) >
    <|input>
      EL(f,a):=block(

      [ret,ddtDL,DLdda, DLda],

      DLdda:diff(f,diff(a,t)),/*print(DLdda),*/

      ddtDL:diff(DLdda,t),/*print(ddtDL),*/

      DLda:diff(f,a),/*print(DLda),*/

      ret:ddtDL-DLda,

      return(ret)

      )$
    </input>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>11) >
    <|unfolded-io>
      ztilde:append(z,lambda)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o11>)
      >><matrix|<tformat|<table|<row|<cell|x<rsub|1>>>|<row|<cell|x<rsub|2>>>|<row|<cell|y<rsub|1>>>|<row|<cell|y<rsub|2>>>|<row|<cell|u<rsub|1>>>|<row|<cell|u<rsub|2>>>|<row|<cell|l<rsub|1>>>|<row|<cell|l<rsub|2>>>|<row|<cell|l<rsub|3>>>|<row|<cell|l<rsub|4>>>>>>>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>12) >
    <|input>
      eqs(f,z):=block(

      [eq:[]],

      \ \ for i:1 thru length(z) do(

      \ \ \ \ eq:append(eq,[EL(Le,z[i,1])])

      \ \ ),

      \ \ \ return(eq)

      )$
    </input>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>13) >
    <|unfolded-io>
      eq:eqs(Le,ztilde)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o13>)
      >><around*|[|<around*|(|l<rsub|1>|)><rsub|t>,<around*|(|l<rsub|2>|)><rsub|t>+l<rsub|1>,<around*|(|l<rsub|3>|)><rsub|t>,<around*|(|l<rsub|4>|)><rsub|t>+l<rsub|3>,l<rsub|2>,l<rsub|4>,x<rsub|2>-<around*|(|x<rsub|1>|)><rsub|t>,u<rsub|1>-<around*|(|x<rsub|2>|)><rsub|t>,y<rsub|2>-<around*|(|y<rsub|1>|)><rsub|t>,u<rsub|2>-<around*|(|y<rsub|2>|)><rsub|t>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>14) >
    <|unfolded-io>
      t[i]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o14>)
      >>t<rsub|i>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>15) >
    <|unfolded-io>
      t[f]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o15>)
      >>t<rsub|f>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>16) >
    <|unfolded-io>
      eq[1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o16>)
      >><around*|(|l<rsub|1>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>17) >
    <|unfolded-io>
      eq[2]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o17>)
      >><around*|(|l<rsub|2>|)><rsub|t>+l<rsub|1>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>18) >
    <|unfolded-io>
      eq[3]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o18>)
      >><around*|(|l<rsub|3>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>19) >
    <|unfolded-io>
      eq[4]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o19>)
      >><around*|(|l<rsub|4>|)><rsub|t>+l<rsub|3>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>20) >
    <|unfolded-io>
      eq[5]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o20>)
      >>l<rsub|2>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>21) >
    <|unfolded-io>
      eq[6]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o21>)
      >>l<rsub|4>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>22) >
    <|unfolded-io>
      eq[7]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o22>)
      >>x<rsub|2>-<around*|(|x<rsub|1>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>23) >
    <|unfolded-io>
      eq[8]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o23>)
      >>u<rsub|1>-<around*|(|x<rsub|2>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>24) >
    <|unfolded-io>
      eq[9]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o24>)
      >>y<rsub|2>-<around*|(|y<rsub|1>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>25) >
    <|unfolded-io>
      eq[10]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o25>)
      >>u<rsub|2>-<around*|(|y<rsub|2>|)><rsub|t>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>31) >
    <|unfolded-io>
      stateX:[eq[7]=0,eq[8]=0]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o31>)
      >><around*|[|x<rsub|2>-<around*|(|x<rsub|1>|)><rsub|t>=0,u<rsub|1>-<around*|(|x<rsub|2>|)><rsub|t>=0|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>38) >
    <|unfolded-io>
      solX:solve(stateX,[diff(x[1],t),diff(x[2],t)])[1]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o38>)
      >><around*|[|<around*|(|x<rsub|1>|)><rsub|t>=x<rsub|2>,<around*|(|x<rsub|2>|)><rsub|t>=u<rsub|1>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>29) >
    <|unfolded-io>
      stateY:[eq[9],eq[10]]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o29>)
      >><around*|[|y<rsub|2>-<around*|(|y<rsub|1>|)><rsub|t>,u<rsub|2>-<around*|(|y<rsub|2>|)><rsub|t>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>37) >
    <|unfolded-io>
      solY:solve(stateY,[diff(y[1],t),diff(y[2],t)])[1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o37>)
      >><around*|[|<around*|(|y<rsub|1>|)><rsub|t>=y<rsub|2>,<around*|(|y<rsub|2>|)><rsub|t>=u<rsub|2>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>44) >
    <|unfolded-io>
      x[2]:integrate(part(solX,2,2),t,t[i],tau)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o44>)
      >>u<rsub|1>*<around*|(|\<tau\>-t<rsub|i>|)>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>46) >
    <|unfolded-io>
      x[1]:expand(integrate(x[2],tau,t[i],t))
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o46>)
      >><frac|u<rsub|1>*t<rsup|2>|2>-u<rsub|1>*t<rsub|i>*t+<frac|u<rsub|1>*t<rsub|i><rsup|2>|2>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>48) >
    <|unfolded-io>
      y[2]:integrate(part(solY,2,2),t,t[i],tau)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o48>)
      >>u<rsub|2>*<around*|(|\<tau\>-t<rsub|i>|)>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>49) >
    <|unfolded-io>
      y[1]:expand(integrate(y[2],tau,t[i],t))
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o49>)
      >><frac|u<rsub|2>*t<rsup|2>|2>-u<rsub|2>*t<rsub|i>*t+<frac|u<rsub|2>*t<rsub|i><rsup|2>|2>>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>50) >
    <|input>
      \;
    </input>
  </session>
</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>