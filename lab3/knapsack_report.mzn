include "disjoint.mzn";

enum ITEM;
int: knapsack_n;
array[1..knapsack_n] of int: capacities;
array[ITEM] of int: profits;
array[ITEM] of int: weights;

array[1..knapsack_n] of var set of ITEM: knapsacks;

constraint forall(k in 1..knapsack_n)(
    sum(i in knapsacks[k])(weights[i]) <= capacities[k]
);

constraint forall(i, j in 1..knapsack_n)(
    if i != j then disjoint(knapsacks[i], knapsacks[j]) endif
);

var int: profit = sum(k in 1..knapsack_n)(sum(i in knapsacks[k])(profits[i]));

% Reprezentacja przypisania kompatybilna z notebookiem: 0 = poza plecakami, 1..knapsack_n = numer plecaka.
array[ITEM] of var 0..knapsack_n: x =
    [sum(k in 1..knapsack_n)(k * bool2int(i in knapsacks[k])) | i in ITEM];

array[1..knapsack_n] of var int: items_in_knapsack =
    [sum(i in ITEM)(bool2int(x[i] == k)) | k in 1..knapsack_n];
var int: items_outside = sum(i in ITEM)(bool2int(x[i] == 0));
var bool: packing_rules_ok =
    forall(k in 1..knapsack_n)(items_in_knapsack[k] >= 2) /\ (items_outside >= 2);

solve maximize profit;

output [
    "profit=" ++ show(profit) ++ "\n",
    "x=" ++ show([fix(x[i]) | i in ITEM]) ++ "\n",
    "items_in_knapsack=" ++ show([fix(items_in_knapsack[k]) | k in 1..knapsack_n]) ++ "\n",
    "items_outside=" ++ show(fix(items_outside)) ++ "\n",
    "packing_rules_ok=" ++ show(fix(packing_rules_ok)) ++ "\n"
];
