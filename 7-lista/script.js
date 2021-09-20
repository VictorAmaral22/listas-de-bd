var array = [
    ['cpf'], 
    ['data', 'dataUtil'],
    ['valor'],
    ['op1','selectOp','op2']];

function valid(value) {
    var errors = 0;
    console.log('Valores de '+array[value-1]);
    for(let i=0; i < array[value-1].length ;i++){
        let input = document.getElementById(array[value-1][i]);
        let regExp = new RegExp(input.pattern);
        if(regExp.test(input.value)){
            if(i == (array[value-1].length-1) && errors == 0){
                console.log('RegExp ok!');
                if(value == 1){
                    var ok = validateCpf();
                    if(ok){
                        console.log('Sucesso!');
                        document.getElementById('form'+value).submit();
                    } else {
                        console.log('Erro em '+input.id+': '+input.value);
                        input.value = '';
                        input.classList.add('erro');
                        errors++;
                    }
                }
            }
        } else {
            console.log('Erro em '+input.id+': '+input.value);
            input.value = '';
            input.classList.add('erro');
            errors++;
        }
    }
}

function validateCpf(){
    var invalidCPF = [
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
    ];
    var cpf = document.getElementById('cpf').value;
    console.log('Validando CPF: '+cpf);
    if(invalidCPF.includes(cpf)){
        console.log('CPF inválido!')
        return null;
    } else{
        // usando um CPF fictício "52998224725".
        // 5 * 10 + 2 * 9 + 9 * 8 + 9 * 7 + 8 * 6 + 2 * 5 + 2 * 4 + 4 * 3 + 7 * 2
        // 295 * 10 / 11
        
        cpf = cpf.split('');
        var calculo = 0;
        let i = 10;
        cpf.forEach(element => {
            if(i>=2){
                calculo += element*i;
                i--;
            }
        });
        var calculo2 = 0;
        if((calculo*10)%11 == cpf[cpf.length-2]){
            // 5 * 11 + 2 * 10 + 9 * 9 + 9 * 8 + 8 * 7 + 2 * 6 + 2 * 5 + 4 * 4 + 7 * 3 + 2 * 2
            // 347 * 10 / 11
            
            let i = 11;
            cpf.forEach(element => {
                if(i>=2){
                    calculo2 += element*i;
                    i--;
                }
            });
        } else {
            console.log('CPF inválido!');
            return null
        }
        if((calculo2*10)%11 ==  cpf[cpf.length-1]){
            console.log('CPF válido!');
            return true;
        } else {
            console.log('CPF iválido!');
            return null;
        }
    }    
}

function unSetError(value){
    let input = document.getElementById(value);
    input.classList.remove('erro');
}