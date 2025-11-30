# 🎮 Duo Quest

## 🕹️ 1. Sobre o Jogo

**Trabalho de Game Development:** **Duo Quest**

**Descrição:** Um jogo de plataforma 2D desenvolvido no **Godot Engine**, focado na jogabilidade **Cooperativa (Coop)**. Os jogadores devem trabalhar em conjunto para navegar em ambientes desafiadores, utilizando o sistema de pontuação persistente e gerenciando um número limitado de vidas compartilhadas.

**Tecnologia:** Godot Engine (GDScript)

---

## ✨ 2. Arquitetura de Software e Mecânicas Coop

A arquitetura do Duo Quest é baseada em *Singletons* (nós de carregamento automático) para gerenciar o estado do jogo e garantir que a pontuação e as vidas persistam entre as cenas.

### A. Gerenciamento Global (Global Manager)

O script principal (`Global.gd`) centraliza as regras do *Game Loop* e do modo cooperativo.

| Variável / Função | Função no Jogo | Princípio de Design | 
| :--- | :--- | :--- | 
| `player1_alive`, `player2_alive` | Monitora o estado de vida de cada um dos avatares. | **Coop-Critical:** O jogo só perde uma vida (`lives -= 1`) quando **ambos** os jogadores estão inativos. | 
| `score_at_level_start` | Salva o score acumulado antes de iniciar a fase. | **Justiça na Punição:** Em caso de morte, o score é revertido para este valor, penalizando apenas o progresso da fase atual. | 
| `restart(time)` | Gerencia a perda de vida e a transição de cena, com um `await` de tempo para dar **feedback** antes do *respawn*. | **Ciclo de Jogo:** Controla o fluxo de reinicialização e `game_over`. | 

### B. Lógica de Combate e Feedback

O combate é projetado para oferecer um feedback tátil e visual gratificante.

| Código (GDScript) | Feedback ou Mecânica | Princípio de Design | 
| :--- | :--- | :--- | 
| `area.get_parent().velocity.y = -450` | Impulso vertical no jogador após a destruição do inimigo. | **Game Feel / Recompensa:** Confirma a vitória com movimento do personagem. | 
| `$AnimatedSprite2D.play("Hit")` | Executa a animação de dano do inimigo. | **Feedback Imediato:** Comunica o sucesso do ataque. | 
| `if distance_traveled >= max_distance: queue_free()` | Projétil se autodestrói ao atingir o limite de alcance. | **Otimização (TTL):** Evita que projéteis inativos consumam recursos da memória. | 

### C. Persistência de Dados (ScoreManager)

O `ScoreManager.gd` é um Singleton dedicado à persistência do placar, estendendo o desafio do jogo para o **Meta-Game**.

* **Implementação:** Utiliza `FileAccess.open` e `JSON.stringify` para salvar o *array* de pontuações no arquivo `user://highscores.save`.

* **Ordenação e Otimização:** O script ordena as pontuações do maior para o menor (`scores.sort_custom`) e limita o array a 100 entradas, mantendo o arquivo de salvamento leve e eficiente.

---

## 🚀 3. Como Rodar o Jogo

Este projeto é nativo do **Godot Engine** e pode ser executado diretamente pelo editor.

### A. No Editor Godot (Para Desenvolvedores)

1.  **Clone o Repositório:** Utilize o Git para clonar a pasta do projeto.

    ```markdown
    git clone [LINK DO SEU REPOSITÓRIO AQUI]
    ```

2.  **Abrir:** Abra o Godot Engine, clique em **"Importar"** e selecione o arquivo `project.godot`.

3.  **Executar:** Pressione o ícone **"Play"** ou a tecla `F5` para rodar o jogo (ou `F6` para rodar a cena atual).

### B. Exportação (Build)

Para gerar um executável (`.exe`, `.apk`, etc.), você deve:

1.  Instalar os **Templates de Exportação** da sua versão do Godot (Menu **"Editor"** $\to$ **"Gerenciar Templates de Exportação..."**).

2.  Configurar o Preset na janela **"Projeto"** $\to$ **"Exportar..."** e definir o **Caminho de Exportação** (`Export Path`).

3.  Clicar em **"Exportar Projeto"**.

---

## 📂 4. Estrutura de Pastas

| Pasta | Conteúdo | Finalidade | 
| :--- | :--- | :--- | 
| **Scripts/** | Todos os arquivos `.gd` (Global.gd, ScoreManager.gd, player.gd, etc.). | Lógica de programação e comportamento dos nós. | 
| **Scene/** | Arquivos `.tscn` das fases, telas de Menu e Game Over. | Estrutura hierárquica e visual do jogo. | 
| **Sprites/** | Assets gráficos, spritesheets e texturas. | Recursos visuais do jogo. | 
| **Sounds/** | Arquivos de áudio (Músicas e Efeitos Sonoros). | Feedback auditivo e trilha sonora. | 
| **project.godot** | Arquivo de configuração raiz do Godot. | Metadados do projeto e configurações de Singletons. |
