<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

<?php

if(!isset($_POST["op1"]) || !isset($_POST["op2"]) || !isset($_POST["selectOp"])){
    echo "DADOS INVÁLIDOS";
} else {
    $op1 = $_POST["op1"];
    $op2 = $_POST["op2"];
    $selectOp = $_POST["selectOp"];

    // print_r($op1);
    // echo '<br>';
    // echo $selectOp.'<br>';
    // print_r($op2);
    // echo '<br>';
    
    function casasCount($array, $offset, $numExt1, $numExt2, $numExt3){
        // echo $array[0].'<br>';
        // echo $offset.'<br>';
        for ($i=0; $i < count($array); $i++) { 
            if($array[$i] != 'e'){
                if($numExt3[$array[$i]]){
                    // echo 'centena<br>';
                    $opNum = $opNum + (int)($numExt3[$array[$i]].$offset);
                }
                if($numExt2[$array[$i]]){
                    // echo 'dezena<br>';
                    $opNum = $opNum + (int)($numExt2[$array[$i]].$offset);
                }
                if($numExt1[$array[$i]]){
                    // echo 'unidade<br>';
                    $opNum = ($opNum + (int)($numExt1[$array[$i]].$offset));
                }
            }
        }
        return $opNum;
    }

    function extToNumber($operador){
        $numExt1 = ['um'=>1, 'dois'=>2, 'três'=>3, 'quatro'=>4, 'cinco'=>5, 'seis'=>6, 'sete'=>7, 'oito'=>8, 'nove'=>9, 'dez'=>10, 'onze'=>11, 'doze'=>12, 'treze'=>13, 'quatorze'=>14, 'quinze'=>15, 'dezesseis'=>16, 'dezessete'=>17, 'dezoito'=>18, 'dezenove'=>19];
        $numExt2 = ['vinte'=>20, 'trinta'=>30, 'quarenta'=>40, 'cinquenta'=>50, 'sessenta'=>60, 'setenta'=>70, 'oitenta'=>80, 'noventa'=>90];
        $numExt3 = ['cem'=>100, 'cento'=>100, 'duzentos'=>200, 'trezentos'=>300, 'quatrocentos'=>400, 'quinhentos'=>500, 'seiscentos'=>600, 'setecentos'=>700, 'oitocentos'=>800, 'novecentos'=>900];

        $opNum = 0;

        $milhExists1 = strpos($operador, 'milhões');
        $milhExists2 = strpos($operador, 'milhão');
        if($milhExists1 !== false){
            // ...
            $milExists = strpos($operador, 'mil', $milhExists1+7);
            $m = substr($operador, 0, $milhExists1);
            if($milExists !== false){
                $k = substr($operador, $milhExists1+8, $milExists-($milhExists1+8));
                $c = substr($operador, $milExists+3);
            } else {
                $c = substr($operador, $milExists+13);
            }
        } 
        if($milhExists2 !== false){
            // ...            
            $milExists = strpos($operador, 'mil', $milhExists2+6);
            $m = substr($operador, 0, $milhExists2);
            if($milExists !== false){
                $k = substr($operador, $milhExists2+6, $milExists-($milhExists1+8));
                $c = substr($operador, $milExists+3);
            } else {
                $c = substr($operador, $milExists+10);
            }
        } 
        if($milhExists1 === false && $milhExists2 === false) {
            $milExists = strpos($operador, 'mil', 3);
            $k = substr($operador, 0, $milExists);
            $c = substr($operador, $milExists+3);
        } 
        if($milExists === false && ($milhExists1 !== false || $milhExists2 !== false)){
            if($milhExists1 !== false){
                $c = substr($operador, $milhExists1+8);
            } 
            if($milhExists2 !== false){
                $c = substr($operador, $milhExists2+6);
            }
        }
        if($milExists === false && $milhExists1 === false && $milhExists2 === false) {
            $c = $operador;
        }
        $m = explode(' ', trim($m));
        $k = explode(' ', trim($k));
        $c = explode(' ', trim($c));
        // echo '<br>Milhão: <br>';
        // print_r($m);
        // echo '<br>Mil: <br>';
        // print_r($k);
        // echo '<br>Centena: <br>';
        // print_r($c);

        // echo '<br>';
        
        if($c[0] != ''){
            $opNum += casasCount($c, '', $numExt1, $numExt2, $numExt3);
        }
        if($k[0] != ''){
            $opNum += casasCount($k, '000', $numExt1, $numExt2, $numExt3);        
        }
        if($m[0] != ''){
            $opNum += casasCount($m, '000000', $numExt1, $numExt2, $numExt3);        
        }        
        // echo $opNum.'<br>';
        return $opNum;
    }
    // op1
    $valor1 = extToNumber($op1);
    $valor2 = extToNumber($op2);
    $result = 0;
    $symbol = '';
    if($selectOp == 'mais'){
        $result = $valor1 + $valor2;
        $symbol = '+';
    }
    if($selectOp == 'menos'){
        $result = $valor1 - $valor2;
        $symbol = '-';
    }
    if($selectOp == 'mult'){
        $result = $valor1 * $valor2;
        $symbol = 'x';
    }
    if($selectOp == 'divd'){
        $result = $valor1 / $valor2;
        $symbol = '/';
    }
   
    echo '<h1>Calculadora</h1>';
    echo $valor1.' '.$symbol.' '.$valor2.' = '.(int)$result;

}

?>
    
</body>
</html>