<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

<?php

echo '<h1>Calculadora</h1><br>';

if(!isset($_POST["op1"]) || !isset($_POST["op2"]) || !isset($_POST["selectOp"])){
    echo "DADOS INVÁLIDOS";
} else {
    $ok = numExtValid();
    if($ok){
        calculadora();
    } else {
        echo "DADOS INVÁLIDOS";
    }
}

function casasOk(){
    $regExp = '^(e )?(ce(nto|m)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}$/';
    $erro = 0;
    if($centena != ''){
        if(preg_match($regExp, $centena)){$erro++;}
    }
    if($mil != ''){
        if(preg_match($regExp, $mil)){$erro++;}
    };
    if($milhao != ''){
        if(preg_match($regExp, $milhao)){$erro++;}
    };
    return $erro === 0 ? true : false;
}

function incongr($array, $numExt){
    $erro = 0;
    for ($i = 0; $i <= count($array)-1; $i++) {
        if($array[$i] != 'e'){
            if(in_array($array[$i], $numExt[1])){
                $c = $array[$i+1] ? ($array[$i+1] == 'e' ? ($array[$i+2] ? 2 : false) : 1) : false;
                if($c && $array[$i+$c]){
                    if(array_search($array[$i+$c], $numExt[0]) > 8){
                        $erro++;
                    }
                }
            }
            if(in_array($array[$i], $numExt[2])){
                $c = $array[$i+1] ? ($array[$i+1] == 'e' ? ($array[$i+2] ? true : false) : false) : false;
                if($c && $array[$i] == 'cem'){$erro++;}
                if(!$c && $array[$i] == 'cento'){$erro++;}
            }
        }                            
    }
    return $erro === 0 ? true : false;
}

function checkNumber($value){
    $numExt = [
        ['um','dois','três','quatro','cinco','seis','sete','oito','nove','dez','onze','doze','treze','quatorze','quinze','dezesseis','dezessete','dezoito','dezenove'], 
        ['vinte','trinta','quarenta','cinquenta','sessenta','setenta','oitenta','noventa'], 
        ['cem','cento','duzentos','trezentos','quatrocentos','quinhentos','seiscentos','setecentos','oitocentos','novecentos']
    ];

    if(preg_match('#^(ce(nto|m)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}( milh(ão|ões) | milh(ão|ões) e | milh(ão|ões)$){0,1}(ce(m|nto)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}(mil |mil e | mil | mil e | mil$){0,1}(ce(m|nto)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( | e |$){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( | e |$){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}$#',
    $value)){
        $num = explode(' ', $value);
        if(in_array('', $num)){
            return false;
        } else {
            $erroMilhao = 0;
            $regExp1 = '/(mil)/';
            $regExp2 = '/( milhão| milhões)/';                
            $mil = ''; $milhao = ''; $centena = '';
            if(preg_match($regExp1, $value) && preg_match($regExp2, $value)){
                preg_match($regExp1, $value, $matchesMil, PREG_OFFSET_CAPTURE);
                preg_match($regExp2, $value, $matchesMilhao, PREG_OFFSET_CAPTURE);
                
                $centena = substr($value, $matchesMil+5);
                $mil = substr($value, $matchesMilhao+8, $matchesMil-($matchesMilhao+8));
                $milhao = substr($value, 0, $matchesMilhao);
                if($milhao == 'um' && strpos('milhões', $value) != -1){
                    $erroMilhao++;
                }
                if($milhao != 'um' && strpos('milhão', $value) != -1){
                    $erroMilhao++;
                }
            } 
            if(!preg_match($regExp1, $value) && preg_match($regExp2, $value)){
                $centena = substr($value, $matchesMilhao+8);
                $milhao = substr($value, 0, $matchesMilhao);
                if($milhao == 'um' && strpos('milhões', $value) != -1){
                    $erroMilhao++;
                }
                if($milhao != 'um' && strpos('milhão', $value) != -1){
                    $erroMilhao++;
                }
            }
            if(preg_match($regExp1, $value) && !preg_match($regExp2, $value)){
                $centena = substr($value, $matchesMil+5);
                $mil = substr($value, 0, $matchesMil);
            }
            if(!preg_match($regExp1, $value) && !preg_match($regExp2, $value)){
                $centena = $value;
            }
            if($erroMilhao != 0){
                return false;
            }

            $centena = trim($centena);
            $mil = trim($mil);
            $milhao = trim($milhao);
            
            $ok = casasOk();
            if($ok){
                $erro = 0;
                if($centena != ''){
                    $centena = explode(' ', $centena);
                    if($mil != '' || $milhao != ''){
                        if(count($centena) <= 2 && $centena[0] != 'e'){$erro++;}
                        if(count($centena) > 2 && $centena[0] == 'e'){$erro++;}
                    }
                    !incongr($centena, $numExt) ? $erro++ : "";
                }
                if($mil != ''){
                    $mil = explode(' ', $mil);
                    if($milhao != ''){
                        if(count($mil) <= 2 && $mil[0] != 'e'){$erro++;}
                        if(count($mil) > 2 && $mil[0] == 'e'){$erro++;}
                    }
                    !incongr($mil, $numExt) ? $erro++ : "";
                };
                if($milhao != ''){
                    $milhao = explode(' ', $milhao);
                    !incongr($milhao, $numExt) ? $erro++ : "";
                };
                return $erro == 0 ? true : false;
            } else {
                return false;
            }
        }
    } else {
        echo $value.'<br>';
        return false;
    }
}

function numExtValid(){
    $erro = 0;
    // OPERDADOR 1
    $op1 = $_POST["op1"];
    $op1 = strtolower($op1);
    if(!checkNumber($op1)){
        $erro++;
        echo 'Erro no Op1 <br>';
    }
    // OPERAÇÃO
    $selectOp = $_POST["selectOp"];
    $operations = ['mais', 'menos', 'mult', 'divd'];
    if(!in_array($selectOp, $operations)){
        $erro++;
        echo 'Erro na operação <br>';
    }
    // OPERDADOR 2
    $op2 = $_POST["op2"];
    $op2 = strtolower($op2);
    if(!checkNumber($op2)){
        $erro++;
        echo 'Erro no Op2 <br>';
    }
    return $erro === 0 ? true : false;
}

function calculadora(){
    $op1 = $_POST["op1"];
    $op2 = $_POST["op2"];
    $selectOp = $_POST["selectOp"];
   
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
            $milExists = strpos($operador, 'mil', 2);
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
   
    echo $valor1.' '.$symbol.' '.$valor2.' = '.(int)$result;
}

?>
    
</body>
</html>