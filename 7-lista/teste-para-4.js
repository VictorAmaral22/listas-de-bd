function validateMoney(){
    var erro = 0;
    var string = document.getElementById('valor').value.toLowerCase();
    console.log('Valor passado: '+string);

    // tratamento do valor
    var REreais = /rea[(l)?(is)?]/;
    var REcents = /centavo(s)?/;
    var reais, cents;
    if(REreais.test(string) || REcents.test(string)){
        if(REreais.test(string)){
            reais = string.split(REreais)[0];
            console.log('R$ '+reais);
            if(REcents.test(string)){
                cents = string.split(REreais)[1];
            }
        } else {
            if(REcents.test(string)){
                cents = string.split(REcents)[0];
            }
        }
    } else{
        erro++;
        console.log('Erro!');
    }
    
    // console.log(string);
    var result = [];
    if(string.includes('zero')){
        erro++;
        console.log('Erro!');
    } else {
        var regExp = [
            /^um$/,
            /^dois$/,
            /^três$/,
            /^quatro$/,
            /^cinco$/,
            /^seis$/,
            /^sete$/,
            /^oito$/,
            /^nove$/,
            /^dez$/,
        ];

        let match = 0;
        string.forEach(num => {
            let i = 0;
            // console.log('Number: '+num);
            regExp.forEach(exp => {
                // console.log('Expression: '+exp);          
                // console.log('i '+i);
                // console.log(exp.test(num));
                if(exp.test(num)){
                    result.push(i + 1);
                    match++;
                } else {
                    if((regExp.length-1) == i && match === 0){
                        erro++;
                        console.log('Erro!');
                    }
                    if(match > 1){
                        erro++;
                        console.log('Erro!');
                    }
                }
                i++;
            });
        });
        
        if(erro == 0){
            console.log('Result: '+result);
        }
    }
    
}
