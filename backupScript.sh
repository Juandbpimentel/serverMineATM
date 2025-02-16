#!/bin/bash
echo "Fazendo backup do servidor do Minecraft"

# Enviar comando para parar o servidor via screen
# (usamos a mesma sessão 'mcs' iniciada no startup)
screen -S mcs -p 0 -X stuff '/stop\n'

# Caminho do repositório local
BACKUP_DIR="/home/kinbofox/github/serverMineATM"
DATA=$(date +'%d-%m-%Y-%H:%M')

# Ajustar as permissões para que os arquivos pertençam a 'kinbofox'
chown -R kinbofox:kinbofox "$BACKUP_DIR"
chmod -R 644 "$BACKUP_DIR"
find "$BACKUP_DIR" -type d -exec chmod +x {} \;

# Navegar para o repositório
cd "$BACKUP_DIR" || exit 1

# Garantir que o Git ignore modificadores de acesso
if ! git config --local core.fileMode &>/dev/null; then
    echo "Configurando core.fileMode para ignorar alterações de permissões..."
    git config --local core.fileMode false
fi

# Configurar o Git local com as informações atualizadas
if ! git config --local user.name &>/dev/null; then
    echo "Configurando usuário local do Git..."
    git config --local user.name "Kinbo Fox"
fi

if ! git config --local user.email &>/dev/null; then
    echo "Configurando e-mail local do Git..."
    git config --local user.email "kinbofox@exemplo.com"
fi

# Remover alterações de permissões indesejadas do índice Git
echo "Removendo alterações de permissões do índice do Git..."
git diff --cached --name-only | xargs -I {} git update-index --chmod=-x {}

# Adicionar e commitar as mudanças, se houver
echo "Adicionando arquivos ao repositório..."
git add .
if git diff --cached --quiet; then
    echo "Nenhuma alteração detectada. Nenhum commit necessário."
else
    echo "Fazendo commit..."
    git commit -m "Atualizando servidor com dados do dia $DATA"
    git push || echo "Erro ao fazer o push. Verifique as configurações do repositório remoto."
fi
