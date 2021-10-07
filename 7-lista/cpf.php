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

echo "<h1>Validação de CPF</h1><br>";

if(!isset($_POST["cpf"])){
    echo "CPF NÃO INFORMADO";
} else {
    if(!preg_match("#^[0-9]{11}$#", $_POST["cpf"])){
        echo "CPF INVÁLIDO";
    } else {
        $cpf = $_POST["cpf"];
        $invalidCpf = array (
        '11111111111',
        '22222222222',
        '33333333333',
        '44444444444',
        '55555555555',
        '66666666666',
        '77777777777',
        '88888888888',
        '99999999999',
        '00000000000',
        '12345678912',
        );
        if(in_array($cpf, $invalidCpf)){
            echo "CPF INVÁLIDO";
        } else {
            $cpf = str_split($cpf, 1);
            foreach($cpf as $numero){
                $numero = (int)$numero;
            }
            $calculo = 0;
            $i = 10;
            foreach($cpf as $numero){
                if($i >=2){
                    // echo "$calculo += $numero*$i<br>";
                    $calculo += $numero*$i;
                    $i--;
                }
                
            }
            // echo "Final: $calculo";
            $calculo2 = 0;
            $ii = 11;
            if(($calculo*10)%11 == $cpf[count($cpf)-2]){
                foreach($cpf as $numero){
                    if($ii >=2){
                        // echo "$calculo2 += $numero*$ii<br>";
                        $calculo2 += $numero*$ii;
                        $ii--;
                    }
                }
                if(($calculo2*10)%11 == $cpf[count($cpf)-1]){
                    echo "CPF VÁLIDO!<br>";
                    $cpf = implode('', $cpf);
                    echo substr($cpf, 0, 3).".".substr($cpf, 3, 3).".".substr($cpf, 6, 3)."-".substr($cpf, 9, 2);
                } else {
                    echo "CPF INVÁLIDO!";
                }
            } else {
                echo "CPF INVÁLIDO!";
            }
        }
    }
}

?>

</body>
</html>