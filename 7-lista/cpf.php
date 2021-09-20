<html>
<body>

<?php 

echo "<h3>Validação de CPF...</h3><br>";

if(!isset($_POST["cpf"])){
    echo "CPF NÃO INFORMADO";
} else {
    if(!preg_match("#[0-9]{11}#", $_POST["cpf"])){
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
        
        foreach($invalidCpf as &$invalid){
            if($invalid == $cpf){
                // ...
            }
        }



        // echo substr($cpf, 0, 3).".".substr($cpf, 3, 3).".".substr($cpf, 6, 3)."-".substr($cpf, 9, 2);
    }
}

?>

</body>
</html>