#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.setuptools python3Packages.z3

from z3 import *

ints = {str(v): v for v in Ints("a b c d e f g")}

mapping = dict(zip("abcdefg", [1, 2, 4, 8, 16, 32, 64]))
data = {0: 119, 1: 36, 2: 93, 3: 109, 4: 46, 5: 107, 6: 123, 7: 37, 8: 127, 9: 111}
datai = {v: k for k,v in data.items()}

def undigits(number):
    return int(''.join(str(i) for i in number))

def get_solution(inputs, outputs):
    s = Solver()
    
    for j in ints.values():
        s.add(Or(*[j == x for x in mapping.values()]))
        
        s.add(sum(ints.values()) == sum(mapping.values()))
        
    for num in inputs:
        als = sum([ints[x] for x in num])
        s.add(Or(*[als == opt for opt in data.values()]))
        #s.add(AtMost(*[als == opt for opt in data.values()], 1))
        
    if s.check() != sat:
        print("no solution found")
        return None
    success = s.model()
    s.add(Or(*[ints[str(m)] != success[m] for m in success]))
    if s.check() == sat:
        print("multiple solutions found")
        print(s.model())
        return None
    else:
        res = []
        for n in outputs:
            res.append(datai[success.eval(sum([ints[l] for l in n])).as_long()])
        return undigits(res)
res = 0
for line in open("day8_input"):
    [inp, outp] = [x.split(" ") for x in line.strip().split(" | ")]
    r = get_solution(inp, outp)
    print(r)
    res += r
print("total", res)
