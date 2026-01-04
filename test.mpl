with(MonogenicCert):

#lprint(MonogenicCert:-bergCert(-2, 2, -1, 2));
#lprint(MonogenicCert:-reducedGen(-(x+1)*x^2*(x-1)*(x-2)^2, x));

#lprint(MonogenicCert:-reducedInput(-(x+1)*x^2*(x-1)*(x-2)^2, (x+1)^3, [[-1 <= x, x <= 1], [x = 2]], x));
#lprint(MonogenicCert:-reducedInput(-(x+1)*x^2*(x-1)*(x-2)^2, (x+1)^5, [[-1 <= x, x <= 1], [x = 2]], x));

#lprint(MonogenicCert:-getStrictPos(-(x+1)*x^2*(x-1)*(x-2)^2, (x+1)^5, [[-1 <= x, x <= 1], [x = 2]], x));

#lprint(MonogenicCert:-bergCert(-2, 1, -2, -1, x));
#lprint(MonogenicCert:-bergCert(-1, 2, 1, 2, x));
#lprint(MonogenicCert:-bergCert(-7/8,-1/8, -3/4, -1/4, x));
#lprint(MonogenicCert:-bergCert(-1,-1/2, -1, -3/4, x));
#lprint(MonogenicCert:-bergCert(-1, 1, -1/2, 1, x));
lprint(MonogenicCert:-bergCert(-1, 1, 1/2, 1, x));

