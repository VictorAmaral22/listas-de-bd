<?php

echo "Número aleatório: <br>";
echo "1 - ".number_format(rand(1, 999999999), 0, ',', '.')."<br>";
echo "2 - ".number_format(rand(1, 999999999), 0, ',', '.');

echo "<hr>";

echo "Valor em Reais: <br>";
echo "R$ ".number_format(rand(1, 999999999), 2, ',', '.')."<br>";

echo "<hr>";

echo "String Replace: <br>";
$string = 'três milhão milhões';
$patterns = [
    '/três/',
    '/milhão/',
    '/milhões/'
];
$replacements = [
    'tres',
    'milhao',
    'milhoes'
];

echo "$string<br>";
$string = preg_replace($patterns, $replacements, $string);
echo "$string<br>";