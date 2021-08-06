select datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+265.2); --past year autumnal equinox
select datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1); --past year winter solstice
select datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8); --vernal equinox
select datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6); --summer solstice
select datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2); --autumnal equinox
select datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1); --winter solstice
select datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8); --next vernal equinox

--Começo da estação
select 
    case
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+265.2)
        
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
        
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
        
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
                
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
            datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
        end as estacao

--fim da estação
select 
    case
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
        
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
        
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
        
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
                
        when datetime('now', 'localtime') between 
            datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
            datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
        end as estacao

--pega o começo e o fim da última estação
select tmp1.comecoEstacao, tmp2.fimEstacao from (
    select 
        case
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+265.2)
            
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
            
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
            
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
                    
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
                datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
            end as comecoEstacao
) as tmp1,(
    select 
        case
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
            
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
            
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
            
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
                    
            when datetime('now', 'localtime') between 
                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
                datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
            end as fimEstacao
) as tmp2;
