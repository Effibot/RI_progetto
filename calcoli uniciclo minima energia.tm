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
      integrate(x(t),t)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o4>)
      >><big|int>x<around*|(|t|)>*<space|0.27em>\<mathd\>*<space|0.27em>t>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>5) >
    <|unfolded-io>
      z:matrix([x[1]],[x[2]],[y[1]],[y[2]],[u[1]],[u[2]])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o5>)
      >><matrix|<tformat|<table|<row|<cell|x<rsub|1>>>|<row|<cell|x<rsub|2>>>|<row|<cell|y<rsub|1>>>|<row|<cell|y<rsub|2>>>|<row|<cell|u<rsub|1>>>|<row|<cell|u<rsub|2>>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>6) >
    <|unfolded-io>
      zdot:diff(z,t)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o6>)
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
      L:z[5,1]^2+z[6,1]^2
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o8>)
      >>u<rsub|2><rsup|2>+u<rsub|1><rsup|2>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>9) >
    <|unfolded-io>
      Le:L+transpose(lambda).state
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o9>)
      >>l<rsub|4>*<around*|(|<around*|(|y<rsub|2>|)><rsub|t>-u<rsub|2>|)>+l<rsub|2>*<around*|(|<around*|(|x<rsub|2>|)><rsub|t>-u<rsub|1>|)>+l<rsub|3>*<around*|(|<around*|(|y<rsub|1>|)><rsub|t>-y<rsub|2>|)>+l<rsub|1>*<around*|(|<around*|(|x<rsub|1>|)><rsub|t>-x<rsub|2>|)>+u<rsub|2><rsup|2>+u<rsub|1><rsup|2>>>
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
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o11>)
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
      >><around*|[|<around*|(|l<rsub|1>|)><rsub|t>,<around*|(|l<rsub|2>|)><rsub|t>+l<rsub|1>,<around*|(|l<rsub|3>|)><rsub|t>,<around*|(|l<rsub|4>|)><rsub|t>+l<rsub|3>,l<rsub|2>-2*u<rsub|1>,l<rsub|4>-2*u<rsub|2>,x<rsub|2>-<around*|(|x<rsub|1>|)><rsub|t>,u<rsub|1>-<around*|(|x<rsub|2>|)><rsub|t>,y<rsub|2>-<around*|(|y<rsub|1>|)><rsub|t>,u<rsub|2>-<around*|(|y<rsub|2>|)><rsub|t>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>14) >
    <|unfolded-io>
      stateX:[eq[7]=0,eq[8]=0]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o14>)
      >><around*|[|x<rsub|2>-<around*|(|x<rsub|1>|)><rsub|t>=0,u<rsub|1>-<around*|(|x<rsub|2>|)><rsub|t>=0|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>15) >
    <|unfolded-io>
      solX:solve(stateX,[diff(x[1],t),diff(x[2],t)])[1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o15>)
      >><around*|[|<around*|(|x<rsub|1>|)><rsub|t>=x<rsub|2>,<around*|(|x<rsub|2>|)><rsub|t>=u<rsub|1>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>16) >
    <|unfolded-io>
      stateY:[eq[9],eq[10]]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o16>)
      >><around*|[|y<rsub|2>-<around*|(|y<rsub|1>|)><rsub|t>,u<rsub|2>-<around*|(|y<rsub|2>|)><rsub|t>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>17) >
    <|unfolded-io>
      solY:solve(stateY,[diff(y[1],t),diff(y[2],t)])[1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o17>)
      >><around*|[|<around*|(|y<rsub|1>|)><rsub|t>=y<rsub|2>,<around*|(|y<rsub|2>|)><rsub|t>=u<rsub|2>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>18) >
    <|unfolded-io>
      LL: part(eq,[1,2,3,4,5,6])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o18>)
      >><around*|[|<around*|(|l<rsub|1>|)><rsub|t>,<around*|(|l<rsub|2>|)><rsub|t>+l<rsub|1>,<around*|(|l<rsub|3>|)><rsub|t>,<around*|(|l<rsub|4>|)><rsub|t>+l<rsub|3>,l<rsub|2>-2*u<rsub|1>,l<rsub|4>-2*u<rsub|2>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>19) >
    <|unfolded-io>
      l1:k[1]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o19>)
      >>k<rsub|1>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>20) >
    <|unfolded-io>
      l2:map(rhs,solve(integrate(-subst(l1,l[1],LL[2]),t)+k[2],l[2]))[1]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o20>)
      >>k<rsub|2>-k<rsub|1>*t>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>21) >
    <|unfolded-io>
      l3:k[3]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o21>)
      >>k<rsub|3>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>22) >
    <|unfolded-io>
      l4:map(rhs,solve(integrate(-subst(l3,l[3],LL[4]),t)+k[4],l[4]))[1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o22>)
      >>k<rsub|4>-k<rsub|3>*t>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>23) >
    <|unfolded-io>
      u1:map(rhs,solve(l2=2*u[1],u[1]))[1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o23>)
      >>-<frac|k<rsub|1>*t-k<rsub|2>|2>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>24) >
    <|unfolded-io>
      u2:map(rhs,solve(l4=2*u[2],u[2]))[1]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o24>)
      >>-<frac|k<rsub|3>*t-k<rsub|4>|2>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>25) >
    <|unfolded-io>
      x[2]:integrate(part(solX,2,2),t)+k[5]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o25>)
      >>u<rsub|1>*t+k<rsub|5>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>26) >
    <|unfolded-io>
      x[2]:expand(subst(u[1]=u1,x[2]))
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o26>)
      >>-<frac|k<rsub|1>*t<rsup|2>|2>+<frac|k<rsub|2>*t|2>+k<rsub|5>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>27) >
    <|unfolded-io>
      x[1]:expand(integrate(x[2],t)+k[6])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o27>)
      >>-<frac|k<rsub|1>*t<rsup|3>|6>+<frac|k<rsub|2>*t<rsup|2>|4>+k<rsub|5>*t+k<rsub|6>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>28) >
    <|unfolded-io>
      y[2]:integrate(part(solY,2,2),t)+k[7]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o28>)
      >>u<rsub|2>*t+k<rsub|7>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>29) >
    <|unfolded-io>
      y[2]:expand(subst(u[2]=u2,y[2]))
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o29>)
      >>-<frac|k<rsub|3>*t<rsup|2>|2>+<frac|k<rsub|4>*t|2>+k<rsub|7>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>30) >
    <|unfolded-io>
      y[1]:integrate(y[2],t)+k[8]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o30>)
      >>-<frac|k<rsub|3>*t<rsup|3>|6>+<frac|k<rsub|4>*t<rsup|2>|4>+k<rsub|7>*t+k<rsub|8>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>31) >
    <|unfolded-io>
      sysix:subst(t=t[i],[x[1],x[2]])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o31>)
      >><around*|[|-<frac|k<rsub|1>*t<rsub|i><rsup|3>|6>+<frac|k<rsub|2>*t<rsub|i><rsup|2>|4>+k<rsub|5>*t<rsub|i>+k<rsub|6>,-<frac|k<rsub|1>*t<rsub|i><rsup|2>|2>+<frac|k<rsub|2>*t<rsub|i>|2>+k<rsub|5>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>32) >
    <|unfolded-io>
      sysfx:subst(t=t[f],[x[1],x[2]])
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o32>)
      >><around*|[|-<frac|k<rsub|1>*t<rsub|f><rsup|3>|6>+<frac|k<rsub|2>*t<rsub|f><rsup|2>|4>+k<rsub|5>*t<rsub|f>+k<rsub|6>,-<frac|k<rsub|1>*t<rsub|f><rsup|2>|2>+<frac|k<rsub|2>*t<rsub|f>|2>+k<rsub|5>|]>>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>38) >
    <|input>
      \;
    </input>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>33) >
    <|unfolded-io>
      A1i:coefmatrix([sysix[1],sysix[2]],[t[i]^3,t[i]^2,t[i],1])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o33>)
      >><matrix|<tformat|<table|<row|<cell|-<frac|k<rsub|1>|6>>|<cell|<frac|k<rsub|2>|4>>|<cell|k<rsub|5>>|<cell|k<rsub|5>*t<rsub|i>+k<rsub|6>>>|<row|<cell|0>|<cell|-<frac|k<rsub|1>|2>>|<cell|<frac|k<rsub|2>|2>>|<cell|k<rsub|5>>>>>>>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>34) >
    <|input>
      mycoeff(expr,x,n):=block(

      [coefList:[], i,c],

      for i:0 thru n do(

      c:coeff(expr,x,i),\ 

      coefList:append(coefList,[c])

      ),

      return(coefList)

      )$
    </input>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>35) >
    <|unfolded-io>
      coefx1:mycoeff(x[1],t,3)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o35>)
      >><around*|[|k<rsub|6>,k<rsub|5>,<frac|k<rsub|2>|4>,-<frac|k<rsub|1>|6>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>36) >
    <|unfolded-io>
      coefx2:mycoeff(x[2],t,3)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o36>)
      >><around*|[|k<rsub|5>,<frac|k<rsub|2>|2>,-<frac|k<rsub|1>|2>,0|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>56) >
    <|unfolded-io>
      coefy1:mycoeff(y[1],t,3)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o56>)
      >><around*|[|k<rsub|8>,k<rsub|7>,<frac|k<rsub|4>|4>,-<frac|k<rsub|3>|6>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>38) >
    <|unfolded-io>
      mycoeff(y[2],t,3)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o38>)
      >><around*|[|k<rsub|7>,<frac|k<rsub|4>|2>,-<frac|k<rsub|3>|2>,0|]>>>
    </unfolded-io>

    <\input|Maxima] >
      \;
    </input>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>39) >
    <|unfolded-io>
      q:A*t^3+B*t^2+C*t+D
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o39>)
      >>A*t<rsup|3>+B*t<rsup|2>+C*t+D>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>40) >
    <|unfolded-io>
      v:diff(q,t)
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o40>)
      >>3*A*t<rsup|2>+2*B*t+C>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>41) >
    <|unfolded-io>
      qi:subst(t=t[i],q)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o41>)
      >>A*t<rsub|i><rsup|3>+B*t<rsub|i><rsup|2>+C*t<rsub|i>+D>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>42) >
    <|unfolded-io>
      vi:subst(t=t[i],v)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o42>)
      >>3*A*t<rsub|i><rsup|2>+2*B*t<rsub|i>+C>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>43) >
    <|unfolded-io>
      qf:subst(t=t[f],q)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o43>)
      >>A*t<rsub|f><rsup|3>+B*t<rsub|f><rsup|2>+C*t<rsub|f>+D>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>44) >
    <|unfolded-io>
      vf:subst(t=t[f],v)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o44>)
      >>3*A*t<rsub|f><rsup|2>+2*B*t<rsub|f>+C>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>45) >
    <|unfolded-io>
      AA:coefmatrix([qi,vi,qf,vf],[A,B,C,D])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o45>)
      >><matrix|<tformat|<table|<row|<cell|t<rsub|i><rsup|3>>|<cell|t<rsub|i><rsup|2>>|<cell|t<rsub|i>>|<cell|1>>|<row|<cell|3*t<rsub|i><rsup|2>>|<cell|2*t<rsub|i>>|<cell|1>|<cell|0>>|<row|<cell|t<rsub|f><rsup|3>>|<cell|t<rsub|f><rsup|2>>|<cell|t<rsub|f>>|<cell|1>>|<row|<cell|3*t<rsub|f><rsup|2>>|<cell|2*t<rsub|f>>|<cell|1>|<cell|0>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>46) >
    <|unfolded-io>
      B:matrix([P[i]],[0],[P[f]],[0])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o46>)
      >><matrix|<tformat|<table|<row|<cell|P<rsub|i>>>|<row|<cell|0>>|<row|<cell|P<rsub|f>>>|<row|<cell|0>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>49) >
    <|unfolded-io>
      AA:subst(t[i]=0,AA)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o49>)
      >><matrix|<tformat|<table|<row|<cell|0>|<cell|0>|<cell|0>|<cell|1>>|<row|<cell|0>|<cell|0>|<cell|1>|<cell|0>>|<row|<cell|t<rsub|f><rsup|3>>|<cell|t<rsub|f><rsup|2>>|<cell|t<rsub|f>>|<cell|1>>|<row|<cell|3*t<rsub|f><rsup|2>>|<cell|2*t<rsub|f>>|<cell|1>|<cell|0>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>58) >
    <|unfolded-io>
      syst:invert(AA).B
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o58>)
      >><matrix|<tformat|<table|<row|<cell|<frac|2*P<rsub|i>|t<rsub|f><rsup|3>>-<frac|2*P<rsub|f>|t<rsub|f><rsup|3>>>>|<row|<cell|<frac|3*P<rsub|f>|t<rsub|f><rsup|2>>-<frac|3*P<rsub|i>|t<rsub|f><rsup|2>>>>|<row|<cell|0>>|<row|<cell|P<rsub|i>>>>>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>53) >
    <|unfolded-io>
      coefx1
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o53>)
      >><around*|[|k<rsub|6>,k<rsub|5>,<frac|k<rsub|2>|4>,-<frac|k<rsub|1>|6>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>57) >
    <|unfolded-io>
      coefy1
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o57>)
      >><around*|[|k<rsub|8>,k<rsub|7>,<frac|k<rsub|4>|4>,-<frac|k<rsub|3>|6>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>59) >
    <|unfolded-io>
      A:coefx1[4]=syst[1,1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o59>)
      >>-<frac|k<rsub|1>|6>=<frac|2*P<rsub|i>|t<rsub|f><rsup|3>>-<frac|2*P<rsub|f>|t<rsub|f><rsup|3>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>60) >
    <|unfolded-io>
      B:coefx1[3]=syst[2,1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o60>)
      >><frac|k<rsub|2>|4>=<frac|3*P<rsub|f>|t<rsub|f><rsup|2>>-<frac|3*P<rsub|i>|t<rsub|f><rsup|2>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>61) >
    <|unfolded-io>
      C:coefx1[2]=syst[3,1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o61>)
      >>k<rsub|5>=0>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>62) >
    <|unfolded-io>
      D:coefx1[1]=syst[4,1]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o62>)
      >>k<rsub|6>=P<rsub|i>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>64) >
    <|unfolded-io>
      solve(A,k[1])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o64>)
      >><around*|[|k<rsub|1>=-<frac|12*P<rsub|i>-12*P<rsub|f>|t<rsub|f><rsup|3>>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>65) >
    <|unfolded-io>
      solve(B,k[2])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o65>)
      >><around*|[|k<rsub|2>=-<frac|12*P<rsub|i>-12*P<rsub|f>|t<rsub|f><rsup|2>>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>68) >
    <|unfolded-io>
      solve(C,k[5])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o68>)
      >><around*|[|k<rsub|5>=0|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>69) >
    <|unfolded-io>
      solve(D,k[6])
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o69>)
      >><around*|[|k<rsub|6>=P<rsub|i>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>79) >
    <|unfolded-io>
      Q:subst([A,B,C,D],q)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o79>)
      >>A*t<rsup|3>+B*t<rsup|2>+C*t+D>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>70) >
    <|unfolded-io>
      A:coefy1[4]=syst[1,1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o70>)
      >>-<frac|k<rsub|3>|6>=<frac|2*P<rsub|i>|t<rsub|f><rsup|3>>-<frac|2*P<rsub|f>|t<rsub|f><rsup|3>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>71) >
    <|unfolded-io>
      B:coefy1[3]=syst[2,1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o71>)
      >><frac|k<rsub|4>|4>=<frac|3*P<rsub|f>|t<rsub|f><rsup|2>>-<frac|3*P<rsub|i>|t<rsub|f><rsup|2>>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>72) >
    <|unfolded-io>
      C:coefy1[2]=syst[3,1]
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o72>)
      >>k<rsub|7>=0>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>73) >
    <|unfolded-io>
      D:coefy1[1]=syst[4,1]
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o73>)
      >>k<rsub|8>=P<rsub|i>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>74) >
    <|unfolded-io>
      solve(A,k[3])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o74>)
      >><around*|[|k<rsub|3>=-<frac|12*P<rsub|i>-12*P<rsub|f>|t<rsub|f><rsup|3>>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>75) >
    <|unfolded-io>
      solve(B,k[4])
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o75>)
      >><around*|[|k<rsub|4>=-<frac|12*P<rsub|i>-12*P<rsub|f>|t<rsub|f><rsup|2>>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>77) >
    <|unfolded-io>
      solve(C,k[7])
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o77>)
      >><around*|[|k<rsub|7>=0|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>78) >
    <|unfolded-io>
      solve(D,k[8])
    <|unfolded-io>
      \;

      \ <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o78>)
      >><around*|[|k<rsub|8>=P<rsub|i>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>1) >
    <|unfolded-io>
      depends(q,t)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o1>)
      >><around*|[|q<around*|(|t|)>|]>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>2) >
    <|unfolded-io>
      x:a*sin(q)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o2>)
      >>a*sin <around*|(|q|)>>>
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|(<with|math-font-family|rm|%i>3) >
    <|unfolded-io>
      diff(x)
    <|unfolded-io>
      <math|<with|math-display|true|<text|<with|font-family|tt|color|red|(<with|math-font-family|rm|%o3>)
      >>a*cos <around*|(|q|)>*<around*|(|<frac|d|d*t>*q|)>*d*t+sin
      <around*|(|q|)>*d*a>>
    </unfolded-io>

    <\input>
      <with|color|red|(<with|math-font-family|rm|%i>4) >
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