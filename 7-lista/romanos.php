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

echo "<h3>Números Romanos</h3><br>";

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
                        $op[] = "romanoOp".($i+1);
                        $op[] = "selectRom".($i);
                    }
                }
            }
        }
        if($erros === 0){
            return ['valid' => true, 'array' => $op];
        } else {
            return ['valid' => true];            
        }
    }
    $ok = validFields();
    if($ok['valid']){
        // TODO:
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

        $okAgain = validRoman($ok['array']);
        if($okAgain['valid']){
            // AQUI RODA O RESTO DO PROGRAMA
            // A $okAgain tem no $okAgain['fields'] todos os campos que a pessoa colocou e os valores deles validados
            romanos();
        } else {
            echo "NÚMEROS ROMANOS IVÁLIDOS!";
        }
    } else {
        echo "NÚMEROS ROMANOS INVÁLIDOS?";
    }
}

function romanos(){
    $romanoOp1 = $_POST["romanoOp1"];

    $operador1= $_POST["selectRom1"];

    $romanoOp2= $_POST["romanoOp2"];

    $numeroRomano = "XLIX";
    $numeroRomano2 = "XXI";
    $tempnRomano = $numeroRomano;

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
        for($i=0; $i<(strlen($variavel));$i++){ 
            //echo $variavel[$i].$variavel[$i+1]; //XL LI IX
            //XL tem no $numerosromanos então cortaremos XL
            $part = $variavel[$i].$variavel[$i+1];
                
            //echo $part.'<br>'; // XL LI IX
            //echo array_search($part, $numerosromanos); //
            
            if(array_search($part, $numerosromanos) !== false){
                $value+= array_search($part, $numerosromanos);
                $variavel = substr($variavel,2);
                $i=0;
                //echo $variavel; //IX
            } else {
                $part = $variavel[$i];
                $value+= array_search($part, $numerosromanos);
                $variavel = substr($variavel, 1);
                $i=0;    
            };
            
        };
        echo $value.'<br>'; // 50
    };
    echo traducao($numeroRomano).'<br>';
}

?>

</body>
</html>