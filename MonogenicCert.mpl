MonogenicCert := module() option package;

export bergCert;

    bergCert := proc(a, b, c1, c2)
    local gamma0, gamma1;
        if c1+c2 > a + b then
            lprint("hmm1");
            gamma0 := 2/(b-a)*(b-(c1+c2)/2);
        else 
          if c1+c2 < a + b then
            lprint("hmm2");
            gamma0 := 2/(b-a)*((c1+c2)/2 - a);
          else
            lprint("hmm3");
            gamma0 := (c2-c1)^2/(b-a)^2;
          end if;
        end if;
        gamma1 := (x-c1)*(x-c2) - gamma0*(x-a)*(x-b);
        return [gamma0, gamma1];
    end proc;

end module;
