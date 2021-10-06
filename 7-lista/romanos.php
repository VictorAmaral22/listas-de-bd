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

echo "<h3>Validação de CPF...</h3><br>";

// if(!isset($_POST["romanoOp1"]) || !isset($_POST["romanoOp2"]) || !isset($_POST["selectRom1"])){
//     echo "NÚMEROS ROMANOS INVÁLIDOS";
// } else {
//     for($i = 2; $i <= 10; $i++){
//         if(!isset($_POST["romanoOp".$i]))
//     }
// }

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

?>

</body>
</html>