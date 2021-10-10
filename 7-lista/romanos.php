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

echo "<h1>Números Romanos</h1><br>";

if(!isset($_POST["romanoOp1"]) || !isset($_POST["selectRom1"]) || !isset($_POST["romanoOp2"])){
    echo "NÚMEROS ROMANOS INVÁLIDOS";
} else {
    function validFields(){
        $op = ['romanoOp1', 'selectRom1', 'romanoOp2'];
        $erros = 0;
        for($i = 2; $i <= 9; $i++){
            if((isset($_POST["romanoOp".($i+1)]) && !isset($_POST["selectRom".($i)])) || 
               (!isset($_POST["romanoOp".($i+1)]) && isset($_POST["selectRom".($i)]))){
                $erros++;
            } else {
                if(in_array("romanoOp".($i+1), $op) || in_array("selectRom".($i), $op)){
                    $erros++;
                } else {
                    if(isset($_POST["romanoOp".($i+1)]) && isset($_POST["selectRom".($i)])){
                        $op[] = "selectRom".($i);
                        $op[] = "romanoOp".($i+1);
                    }
                }
            }
        }
        if($erros === 0){
            return ['valid' => true, 'array' => $op];
        } else {
            return ['valid' => false];            
        }
    }
    $ok = validFields();
    if($ok['valid']){
        function validRoman($array){ 
            $fields = [];
            foreach ($array as $key) {
                $fields[$key] = $_POST[$key];
            }
            $err = 0;
            for ($arr = array_keys($fields), $c = 0; $c < count($arr); $c++) { 
                if(preg_match("#^(romanoOp)[0-9]{1,2}$#", $arr[$c])){
                    if(!preg_match("#^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$#", $fields[$arr[$c]])){
                        $err++;
                    }
                    if($fields[$arr[$c]] == ""){
                        $err++;
                    }
                }
                if(preg_match("#^(selectRom)[0-9]{1}$#", $arr[$c])){
                    if(!preg_match("#^(mais|menos|mult|divd)$#", $fields[$arr[$c]])){
                        $err++;
                    }
                }
            }
            if($err === 0){
                return ['valid' => true, 'fields' => $fields];
            } else {
                return ['valid' => false];                
            }
        }
        
        $romanos = validRoman($ok['array']);
        if($romanos['valid']){
            $romanos = $romanos['fields'];
            // print_r($romanos);
            // echo "<br>";
            romanos($romanos);
        } else {
            echo "NÚMEROS ROMANOS IVÁLIDOS!";
        }
    } else {
        echo "NÚMEROS ROMANOS INVÁLIDOS?";
    }
}

function traducao($variavel){
    $numerosromanos = array(
        1000 =>'M',
        900 => 'CM',
        500 =>'D',
        400 => 'CD',
        100 => 'C',
        90 => 'XC',
        50 => 'L',
        40 => 'XL',
        10 => 'X',
        9 => 'IX',
        5 => 'V',
        4 => 'IV',
        1 => 'I',
    );

    $value=0;
    
    if(strlen($variavel)==1){
        $value+= array_search($variavel, $numerosromanos);
    }
    for($i=0; $i < (strlen($variavel)-1);$i++){ 
        if(strlen($variavel)!==1){
            $part = $variavel[$i].$variavel[$i+1];
        } else{
            $part = $variavel[$i];
        }
       
        if(array_search($part, $numerosromanos) !== false){
            $value+= array_search($part, $numerosromanos);
            if(strlen($variavel)!==1){
                $variavel = substr($variavel,2);
            } else{
                $variavel = '';
            }
            $i= -1;
        } else {  
            $part = $variavel[$i];
            $variavel = substr($variavel, strlen($variavel) != 1 ? 1 : "");
            $value+= array_search($part, $numerosromanos);
            $i= -1;
        };
        if(strlen($variavel)==1){
            $value+= array_search($variavel, $numerosromanos);
        }
    };
    return $value;
};

function romanos($romanos){
    $resultado = 0;
    for($i=0; $i < count($romanos); $i++){
        $romanoOp1 = $romanos["romanoOp".($i+1)];
        $operador = $romanos["selectRom".($i+1)];
        $romanoOp2 = $romanos["romanoOp".($i+2)];

        if($romanoOp1 && $operador && $romanoOp2){
            if($i == 0){
                $resultado = traducao($romanoOp1);
                echo $romanos["romanoOp".($i+1)];
            } 
            
            switch ($operador) {
                case 'mais':
                    $resultado +=  traducao($romanoOp2);
                    echo " + ";                
                    echo $romanos["romanoOp".($i+2)];
                    break;
                case 'menos':
                    $resultado -=  traducao($romanoOp2);
                    echo " - ";
                    echo $romanos["romanoOp".($i+2)];
                    break;
                case 'mult':
                    $resultado *=  traducao($romanoOp2);
                    echo " * ";
                    echo $romanos["romanoOp".($i+2)];
                    break;
                case 'divd':
                    $resultado /=  traducao($romanoOp2);
                    echo " / ";
                    echo $romanos["romanoOp".($i+2)];
                    break;
            }
        }
    };      

   echo " = ".$resultado;
}

?>

</body>
</html>