# godot3.2_countdown

Um contador básico armazenando o tempo em um arquivo local

#### Você pode definir
- name_countdown - Nome do contador ```string```
- wait_time - Tempo de espera ```HH:MM:SS```, exemplo: ```00:01:00```
- auto_restart - Auto Reinicialização

*O node "countdown" emite um sinal "finish" quando o contador é finalizado e passa como parâmetro o nome do contador "name_countdown"


#### Exemplos:
- O primeiro parâmetro pode ser o tempo ou null! Se for null, o countdown vai pegar a informação configurada no node
- O segundo parâmetro diz ao contador se ele pode auto-reinicializar ou não, por padrão o valor é "false"


##### Exemplo 1
```
$countdown._start("00:00:15", true) 
```

##### Exemplo 2
```
$countdown._start(null, true) 
```

##### Exemplo 3
```
$countdown._start() 
```

