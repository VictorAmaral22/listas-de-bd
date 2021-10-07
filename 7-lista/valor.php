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

echo "<h1>Transcrição de Valor Monetário</h1><br>";

if(!isset($_POST["valor"])){
    echo "VALOR NÃO INFORMADO";
} elseif(!preg_match("#^[0-9]{1,9},[0-9]{2}$#", $_POST["valor"])){
    echo "VALOR INVÁLIDO";
} else{
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

    echo 'R$ '.$valor.'<br>';
    $valor = explode(',', $valor);
    $text = '';
    $text2 = '';
    if(substr($valor[0], 0) == '0' && strlen($valor[0]) > 1){
        echo "VALOR INVÁLIDO";
    } elseif($valor[1] == '00' && (int)$valor[0] == 0) {
        echo "VALOR INVÁLIDO";       
    } else {
        $casasRe = strlen($valor[0]);        
        $casasCents = strlen($valor[1]);

        // CENTS
        if((int)$valor[1] != 0){
            if($valor[1][0] == '0'){
                $text = $text.$numExt1[(int)$valor[1][1]];
            } elseif((int)$valor[1] < 20) {
                $text = $text.$numExt1[(int)$valor[1]];
            } elseif($valor[1][1] == '0') {
                $text = $text.$numExt2[(int)$valor[1][0]];
            } else {
                $text = $text.$numExt2[(int)$valor[1][0]].' e '.$numExt1[(int)$valor[1][1]];
            }
        }

        // REAIS
        if($valor[0][0] != '0'){
            for($i = 0, $c = $casasRe; $i < $casasRe; $i++, $c--){
                // MILHÃO
                // 000.000.000,00
                if($c == 9){
                    if((int)$valor[0][$i+1] != 0 || (int)$valor[0][$i+2] != 0){
                        if((int)$valor[0][$i] == 1){
                            $text2 = $text2.'cento';
                        } else {
                            $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                        }
                    } else {
                        if((int)$valor[0][$i] == 1){
                            $text2 = $text2.'cem';
                        } else {
                            $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                        }
                    }
                }
                // 00.000.000,00
                if($c == 8){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i] < 2){
                                $text2 = $text2.' e '.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                            } else {
                                $text2 = $text2.' e '.$numExt2[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] < 2){
                            $text2 = $text2.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                        } else {
                            $text2 = $text2.$numExt2[(int)$valor[0][$i]];
                        }
                    }
                }
                // 0.000.000,00
                if($c == 7){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i-1] == 0){
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            } elseif((int)$valor[0][$i-1] != 1) {
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            }
                        }
                        $text2 = $text2.' milhões';
                    } else {
                        $text2 = $text2.$numExt1[(int)$valor[0][$i]];
                        if((int)$valor[0][$i] == 1){
                            $text2 = $text2.' milhão';
                        } else {
                            $text2 = $text2.' milhões';

                        }
                    }
                }
                // MILHAR
                // 000.000,00
                if($c == 6){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i+1] != 0 || (int)$valor[0][$i+2] != 0){
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' cento';
                                } else {
                                    $text2 = $text2.' '.$numExt3[(int)$valor[0][$i]];
                                }
                            } else {
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' e cem';
                                } else {
                                    $text2 = $text2.' e '.$numExt3[(int)$valor[0][$i]];
                                }
                            }
                        }
                    } else {
                        if((int)$valor[0][$i+1] != 0 || (int)$valor[0][$i+2] != 0){
                            if((int)$valor[0][$i] == 1){
                                $text2 = $text2.'cento';
                            } else {
                                $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                            }
                        } else {
                            if((int)$valor[0][$i] == 1){
                                $text2 = $text2.'cem';
                            } else {
                                $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                            }
                        }
                    }
                }
                // 00.000,00
                if($c == 5){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i] < 2){
                                $text2 = $text2.' e '.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                            } else {
                                $text2 = $text2.' e '.$numExt2[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] < 2){
                            $text2 = $text2.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                        } else {
                            $text2 = $text2.$numExt2[(int)$valor[0][$i]];
                        }
                    }
                }
                // 0.000,00
                if($c == 4){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i-1] == 0){
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            } elseif((int)$valor[0][$i-1] != 1) {
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] != 1){
                            $text2 = $text2.$numExt1[(int)$valor[0][$i]];
                        }
                    }
                    if(strlen($valor[0]) > 6){
                        if((int)$valor[0][$i] == 0 && (int)$valor[0][$i-1] == 0 && (int)$valor[0][$i-2] == 0){
                            $text2 = $text2.'';
                        } else {
                            $text2 = $text2.' mil';
                        }
                    } else {
                        if($i != 0){
                            $text2 = $text2.' mil';
                        } else {
                            $text2 = $text2.' mil';
                        }
                    };
                }
                // CENTENA
                // 000,00
                if($c == 3){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i+1] != 0 || (int)$valor[0][$i+2] != 0){
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' cento';
                                } else {
                                    $text2 = $text2.' '.$numExt3[(int)$valor[0][$i]];
                                }
                            } else {
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' e cem';
                                } else {
                                    $text2 = $text2.' e '.$numExt3[(int)$valor[0][$i]];
                                }
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] == 1){
                            $text2 = $text2.' cento';
                        } else {
                            $text2 = $text2.' '.$numExt3[(int)$valor[0][$i]];
                        }
                    }
                }
                // 00,00
                if($c == 2){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i] < 2){
                                $text2 = $text2.' e '.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                            } else {
                                $text2 = $text2.' e '.$numExt2[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] < 2){
                            $text2 = $text2.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                        } else {
                            $text2 = $text2.$numExt2[(int)$valor[0][$i]];
                        }
                    }
                }
                // 0,00
                if($c == 1){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i-1] == 0){
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            } elseif((int)$valor[0][$i-1] != 1) {
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i-1] = 1){
                            $text2 = $text2.$numExt1[(int)$valor[0][$i]];
                        }
                    }
                     
                }
            }
        }
    }

    $realText = ($text2 == 'um') ? 'real' : 'reais';
    $centsText = ($text == 'um') ? 'centavo' : 'centavos';

    if($text2 == ''){
        echo "Por extenso: $text $centsText";
    }
    elseif($text == ''){
        echo "Por extenso: $text2 $realText";
    } else{
        echo "Por extenso: $text2 $realText com $text $centsText";
    }
}

?>

</body>
</html>