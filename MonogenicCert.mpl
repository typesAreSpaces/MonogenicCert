# TODO:
# - Import `strictly positive certificates' package
# - Import `basic lemma' package

$define ENABLE_DEBUGGING  true
$define DEBUG(F, L, y, x) if (y) then lprint(">> Debugging file ", F, " at line ", L); x; end if

with(SolveTools, SemiAlgebraic);
#SemiAlgebraic([poly_1 >= 0, ..., poly_n >= 0],[x])
# This returns a list of inequalities of the form
# [[-`leftendpoint_1'<= x, x <= `rightendpoint_1'], ..., [-`leftendpoint_m'<= x, x <= `rightendpoint_m']]

MonogenicCert := module() option package;

local Ord;
local Eps;

  Ord := proc(f, x, point)
  local g, y;
    g := subs(x = y + point, f);
    return ldegree(expand(g), y);
  end proc;

  Eps := proc(f, x, point)
  local g, y;
    g := subs(x = y + point, f);
    return tcoeff(expand(g), y);
  end proc;

export bergCert;

  bergCert := proc(a, b, c1, c2, x)
  local gamma0, gamma1;
    if c1+c2 > a + b then
      gamma1 := 2/(b-a)*(b-(c1+c2)/2);
    else 
      if c1+c2 < a + b then
        gamma1 := 2/(b-a)*((c1+c2)/2 - a);
      else
        gamma1 := (c2-c1)^2/(b-a)^2;
      end if;
    end if;
    gamma0 := (x-c1)*(x-c2) - gamma1*(x-a)*(x-b);
    return [gamma0, gamma1];
  end proc;

export reducedGen;
export reducedInput;

  reducedGen := proc(g, x)
  DEBUG(__FILE__, __LINE__, ENABLE_DEBUGGING, lprint(">> g", g));
  local intervals := SemiAlgebraic([g >= 0], [x]);
  local i, size := nops(intervals);
  local lowerbound, upperbound, isolatedA;

  local isolatedPoints := [];
  local output := -1;
  local outputNoIsolA := -1;
  local temp;

    for i from 1 to size do
      if nops(intervals[i]) = 1 then
        isolatedA := op(intervals[i, 1])[2];
        isolatedPoints := [op(isolatedPoints), isolatedA];
        output := output * (x - isolatedA)^Ord(g, x, isolatedA);
      else
        lowerbound := op(intervals[i, 1])[1];
        upperbound := op(intervals[i, 2])[2];
        temp := (x - lowerbound)^Ord(g, x, lowerbound)
          * (x - upperbound)^Ord(g, x, upperbound);
        output := output * temp;
        outputNoIsolA := outputNoIsolA * temp;
      end if;
    end do;

    return output, outputNoIsolA, intervals, isolatedPoints;
  end proc;

local redundantSoS;

  redundantSoS := proc(f, x, point, ord_f, ord_g)
    local redundant_sos;
    local _eps := Eps(f, x, point);
    if _eps > 0 and type(ord_f, even) then
      redundant_sos := (x - point)^ord_f;
    end if;

    if _eps < 0 and type(ord_f, even) and type(ord_g, even) then
      redundant_sos := (x - point)^(ord_f - ord_g);
    end if;
    # Cannot happen
    if _eps < 0 and type(ord_f, even) and type(ord_g, odd) then
      redundant_sos := (x - point)^(ord_f-1 - ord_g);
    end if;

    if type(ord_f, odd) and type(ord_g, even) then
      redundant_sos := (x - point)^(ord_f-1 - ord_g);
    end if;
    if type(ord_f, odd) and type(ord_g, odd) then
      redundant_sos := (x - point)^(ord_f - ord_g);
    end if;

    return redundant_sos;
  end proc;

  withoutSOS := proc(f, x)
    local endpoints := map(
      interval-> 
        if type(interval, RealRange) then
          op(interval)
        else
          interval
        end if, [solve(f >= 0, x)]);
    local output := 1;
    local size := nops(endpoints);
    local i, point;
    for i from 1 to size do
      point := endpoints[i];
      if (point = -infinity or point = infinity) then
        next;
      end if;
      output := output*(x - point)^Ord(f, x, point);
    end do;
    return (if lcoeff(f) > 0 then 1 else -1 end if)*output;
  end proc;

  reducedInput := proc(g, f, intervals, x)
  local i, size := nops(intervals);
  local f_1, f_2;
  local lowerbound, upperbound, isolatedA;
  local ord_g, ord_f;
  local redundant_sos := 1;

    for i from 1 to size do
      DEBUG(__FILE__, __LINE__, ENABLE_DEBUGGING, lprint(">> redundant_sos (loop)", redundant_sos));
      if nops(intervals[i]) = 1 then
        isolatedA := op(intervals[i, 1])[2];
        ord_g := Ord(g, x, isolatedA);
        ord_f := Ord(f, x, isolatedA);
        if ord_f > 0 then
          redundant_sos := redundant_sos * redundantSoS(f, x, isolatedA, ord_f, ord_g);
        end if;
      else
        lowerbound := op(intervals[i, 1])[1];
        ord_g := Ord(g, x, lowerbound);
        ord_f := Ord(f, x, lowerbound);
        if ord_f > 0 then
          redundant_sos := redundant_sos * redundantSoS(f, x, lowerbound, ord_f, ord_g);
        end if;

        upperbound := op(intervals[i, 2])[2];
        ord_g := Ord(g, x, upperbound);
        ord_f := Ord(f, x, upperbound);
        if ord_f > 0 then
          redundant_sos := redundant_sos * redundantSoS(f, x, upperbound, ord_f, ord_g);
        end if;
      end if;
    end do;

    f_1 := simplify(f / redundant_sos);
    DEBUG(__FILE__, __LINE__, ENABLE_DEBUGGING, lprint(">> f_1", f_1));
    DEBUG(__FILE__, __LINE__, ENABLE_DEBUGGING, lprint(">> redundant_sos", redundant_sos));

    f_2 := withoutSOS(f_1, x);
    DEBUG(__FILE__, __LINE__, ENABLE_DEBUGGING, lprint(">> f_2 ", f_2));

    redundant_sos := redundant_sos * simplify(f_2 / f_1);
    return f_2, redundant_sos;
  end proc;

export getStrictPos;
  getStrictPos := proc(g, f, intervals, x)
  local i, size := nops(intervals); 
  local endpoints := map(
      interval-> 
        if type(interval, RealRange) then
          op(interval)
        else
          interval
        end if, [solve(f >= 0, x)]);

    # TODO Process left part
    # TODO Process right part
    # TODO Process in-between part

    return f;
  end proc;

export getIsolatedTypeA;
  getIsolatedTypeA := proc(g, x)
    return g;
  end proc;

export transformedGen;
export transformedInput;

  transformedGen := proc(g, A, x)
    return g;
  end proc;

  transformedGen := proc(g, f, A, x)
      return g;
  end proc;

export certificateInBetween;
export combineCert;

  certificateInBetween := proc(g, bi, ai1, x)
    return g;
  end proc;

  combineCert := proc(sigma0, sigma1, sigma2, sigma3, x)
    return sigma0;
  end proc;

export cert;
  cert := proc(g, f, x)
    return g;
  end proc;

end module;
