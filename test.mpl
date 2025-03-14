with(MonogenicCert):

#lprint(MonogenicCert:-bergCert(-2, 2, -1, 2));
#lprint(MonogenicCert:-reducedGen(-(x+1)*x^2*(x-1)*(x-2)^2, x));

#lprint(MonogenicCert:-reducedInput(-(x+1)*x^2*(x-1)*(x-2)^2, (x+1)^3, [[-1 <= x, x <= 1], [x = 2]], x));
#lprint(MonogenicCert:-reducedInput(-(x+1)*x^2*(x-1)*(x-2)^2, (x+1)^5, [[-1 <= x, x <= 1], [x = 2]], x));

lprint(MonogenicCert:-getStrictPos(-(x+1)*x^2*(x-1)*(x-2)^2, (x+1)^5, [[-1 <= x, x <= 1], [x = 2]], x));
