# Introduction des différents procceseurs

L'objectif de ce répertoire est de proposé des versions simples de processeurs RISC-V, de permettre de les tester à l'aide de modelsim et de [Rars](https://github.com/TheThirdOne/rars) _RISC-V Assembler and Runtime Simulator_

Trois type de processeur sont disponibles : Monocycle, pipepline et pipeline out-of-order

Le processeur monocycle est un processeur lent qui réalise une instruction par cycle. Les deux processeurs pipelines sont des pipelines de 5 étages avec les différentes étapes:

- IF : Le programme counter donne l'addresse de la nouvelle instruction
- ID : L'instruction est envoyer à l'unit de controle qui va decoder l'instruction pour l'alu.
- EX : L'alu calcul le bit qui permet les sauts et branchements et une unité se charge de calculer le nouveau pc.
- MEM : On peut load ou store des données de la mémoire de données
- WB : On écrit dans le regitre destination la donnée. 

Le pipeline out-of-ordre utilise une mémoire cache pour prédire si la branch est prise ou non.

On utilise une mémoire à addressage directe, avec un index de 10 bits et un tag de 20 bits et on a deux bits pour gérer la prédiction de branch.

## Prise en main de Rars

Pour tester le bon fonctionnement de notre processeur, on va utiliser modelsim et rars.

On peut utiliser le code source la page rars, mais j'ai aussi implémenter un bubble sort en risc-v pour permettre de tester nos diférents processeurs.
