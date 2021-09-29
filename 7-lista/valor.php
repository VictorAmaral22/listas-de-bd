<html>
<body>

<?php 

echo "<h3>Transcrição de Valor Monetário...</h3><br>";

if(!isset($_POST["valor"])){
    echo "VALOR NÃO INFORMADO";
} else {
    $valor = $_POST["valor"];
    $numExt1 = array(
        0=>'',
        1=>'um',
        2=>'dois',
        3=>'três',
        4=>'quatro',
        5=>'cinco',
        6=>'seis',
        7=>'sete',
        8=>'oito',
        9=>'nove',
        10=>'dez',
        11=>'onze',
        12=>'doze',
        13=>'treze',
        14=>'quatorze',
        15=>'quinze',
        16=>'dezesseis',
        17=>'dezessete',
        18=>'dezoito',
        19=>'dezenove'
    );
    $numExt2 = array(
        2=>'vinte',
        3=>'trinta',
        4=>'quarenta',
        5=>'cinquenta',
        6=>'sessenta',
        7=>'setenta',
        8=>'oitenta',
        9=>'noventa'        
    );
    $numExt3 = array(
        1=>'cem',
        2=>'duzentos',
        3=>'trezentos',
        4=>'quatrocentos',
        5=>'quinhentos',
        6=>'seiscentos',
        7=>'setecentos',
        8=>'oitocentos',
        9=>'novecentos'        
    );

    // valor = valor.split(',');
    // if(valor[0].charAt(0) == '0' && valor[0].length > 1){
    //     console.log('Erro!');
    //     return null;
    // } else {
    //     if(valor[1] == '00' && parseInt(valor[0]) == 0){
    //         console.log('Erro!');
    //         return null;
    //     } else {
    //         console.log('Sucesso!');
    //         return true;
    //     }
    // } 
    $valor.str_split(',');
    // if(valor[0].strpos('0') != -1)
    if(substr($valor[0], 0) == '0' && strlen($valor[0]) > 1){
        echo 'Valor inválido';
    } elseif($valor[1] == '00' && (int)$valor[0] == 0) {
        echo 'Valor inválido';       
    } else {
        echo 'R$ '.$valor.'<br>';
        $casasRe = strlen($valor[0]);        
        $casasCents = strlen($valor[1]);
        $text = '';
        if(substr($valor[1], 0) == '0'){
            echo substr($valor[1], 1);
            // echo array_search(, $numExt1);
        }
    }
    // echo array_search(0, $numExt1);
}

?>

</body>
</html>