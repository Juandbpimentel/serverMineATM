#!/bin/bash
echo "Fazendo backup do servidor do Minecraft..."

# Enviar comando para parar o servidor via screen
screen -S mcs -p 0 -X stuff '/stop\n'

# Caminho do repositório local
BACKUP_DIR="/home/kinbofox/github/serverMineATM"
DATA=$(date +'%d-%m-%Y-%H:%M')

# Ajustar as permissões para que todos os usuários tenham leitura, escrita e execução
chmod -R 777 "$BACKUP_DIR"

# Navegar para o repositório
cd "$BACKUP_DIR" || exit 1

# Garantir que o Git ignore modificadores de acesso
git config --local core.fileMode false

# Configurar o Git local com as informações atualizadas
git config --local user.name "Juan Pimentel"
git config --local user.email "juandbpimentel@alu.ufc.br"

# Remover alterações de permissões indesejadas do índice Git
git diff --cached --name-only | xargs -I {} git update-index --chmod=-x {}

# Adicionar e commitar as mudanças, se houver
git add .
if git diff --cached --quiet; then
    echo "Nenhuma alteração detectada. Nenhum commit necessário."
else
    git commit -m "Atualizando servidor com dados do dia $DATA"
    git push || echo "Erro ao fazer o push. Verifique as configurações do repositório remoto."
fi

