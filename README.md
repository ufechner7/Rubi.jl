# Rubi.jl
### Symbolic, rule based integration in Julia

RUBI is a freely available, rule-based integrator. 
(See: https://rulebasedintegration.org/ )

This package shall provide a pure Julia implemetation of 
this integrator.

## Current status

When you install this package with the command:

```
using Pkg
Pkg.add(url="https://github.com/ufechner7/Rubi.jl")
Pkg.dev("Rubi")
```
the following happens:

1. the rules in pdf format are downloaded and installed in the doc folder
2. the rules in Mathematica format are download and installed in the input folder
3. in all files and folders the spaces are replaced by an underscore

You can now find the source code of the package and the documentation in the folder:
```
~/.julia/dev/Rubi
```

## TODO

1. write a function that extracts the rules in text format from the files in the input folder and stores them in a .yaml file.

2. define the interface to Symbolics.jl
3. create a manual example in Julia that applies one rule
4. create a code generator that creates the Julia code for all rules
5. add tests

## Example for some rules

Rule 1.1.1.1.1
```
Int[1/x_,x_Symbol] := 
    Log[x]
```

Rule 1.1.1.1.2
```
Int[x_^m_.,x_Symbol] :=
    x^(m+1)/(m+1)/;
FreeQ[m,x] && NeQ[m,-1]
```
Remark: The last line describes the condition under which the rule applies
