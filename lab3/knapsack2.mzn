include "disjoint.mzn";

enum ITEM;
int: knapsack_n; 
array[1..knapsack_n] of int: capacities;

array[ITEM] of int: profits;
array[ITEM] of int: weights;
var int: profit = sum (k in 1..knapsack_n) (sum(i in knapsacks[k]) (profits[i]));
array[1..knapsack_n] of var set of ITEM: knapsacks;

constraint forall(k in 1..knapsack_n) (sum (i in knapsacks[k]) (weights[i]) <= capacities[k]);


constraint forall(i,j in 1..knapsack_n) (if i != j then disjoint(knapsacks[i], knapsacks[j]) endif);
solve maximize profit ;

output [
    "--- RAPORT PAKOWANIA ---\n"
] ++ [
    "Plecak \(k) (limit: \(capacities[k])):\n" ++
    "  Zawartość: { " ++ join(", ", [show(i) | i in fix(knapsacks[k])]) ++ " }\n" ++
    "  Waga:      \(sum(i in knapsacks[k])(weights[i]))\n" ++
    "  Zysk:      \(sum(i in knapsacks[k])(profits[i]))\n" ++
    "------------------------\n"
    | k in 1..knapsack_n
] ++ [
    "ZYSK: \(profit)"
];

