# Loop 23:47 — vertical slice

Protótipo 3D em primeira pessoa para Godot 4.x. O relógio avança de 23:47 até 00:00; o cenário recarrega a cada loop, enquanto o conhecimento do jogador permanece.

## Executar

1. Abra `project.godot` no Godot 4.x.
2. Pressione **F6/F5** ou use **Executar projeto**.

O protótipo não depende de assets externos. A casa, os móveis e a iluminação são criados com primitivas.

## Controles

- `WASD`: mover
- Mouse: olhar
- `Shift`: correr
- `Espaço`: pular
- `E`: interagir
- `Esc`: capturar/liberar o mouse

## Fluxo demonstrativo

- A casa inicial funciona como lobby/tutorial. Concluir o dossiê libera o elevador para o jogo principal.
- Às 23:51 o NPC deixa a chave do escritório na mesa da cozinha.
- Às 23:54 ele tenta recolhê-la.
- A chave abre o escritório, onde o bilhete revela `1987`.
- Examinar o bilhete grava o conhecimento entre loops.
- Sabendo `1987`, o cofre da sala pode ser aberto diretamente nos loops seguintes.
- O cofre entrega um fusível físico. Instalá-lo no quadro do corredor abre a sala de arquivo.
- O dossiê do arquivo revela uma nova informação persistente sobre o evento de 00:00.
- O Setor de Pesquisa começa às 23:35, possui salas maiores e minutos mais lentos que o lobby.
- Às 00:00 a cena escurece e reinicia; inventário e cenário são recriados, mas conhecimento e contador de loops ficam nos AutoLoads.

O narrador acompanha a progressão pela HUD. Ele começa cooperativo, tenta direcionar as escolhas do jogador e fica mais irritado quando suas instruções são contrariadas.

### Puzzle do Setor de Pesquisa

O distribuidor central só permite energizar uma ala por loop:

- O **Arquivo** contém a sequência `4-1-3-2`, preservada como conhecimento.
- O **Laboratório** disponibiliza um cartão físico, perdido às 00:00.
- O terminal de Observação exige os dois. Escolher o Laboratório primeiro desperdiça o cartão; aprender a sequência antes permite concluir no loop seguinte.

O narrador tenta induzir o jogador a escolher primeiro o caminho menos eficiente. Contrariá-lo e combinar informações de loops diferentes aumenta sua irritação.

## Ajustes rápidos

Em `autoload/time_manager.gd`, `seconds_per_game_minute` define quantos segundos reais dura cada minuto, e `time_scale` multiplica a velocidade. O padrão completa um loop em aproximadamente 65 segundos.

Os nós `ScheduledEvent` em `scenes/main/main.tscn` configuram horários e ações sem concentrar a cronologia em um script único. Os `NPCPoint_*` configuram a rotina do NPC pelo Inspector.

Para executar o teste de integração pelo terminal, substitua `godot4` pelo caminho do seu executável se necessário:

```bash
godot4 --headless --path . res://tests/integration_smoke_test.tscn
godot4 --headless --path . res://tests/research_wing_test.tscn
```

## Placeholders

Porta, passos, telefone, energia e impacto da meia-noite ainda usam nós de áudio sem arquivos. A trilha ambiente já é gerada proceduralmente em tempo real. O personagem possui um modelo low-poly articulado provisório; arte e animações finais continuam pendentes.
