#!/bin/bash
echo "Fazendo backup do servidor do Minecraft..."

# Enviar comando para parar o servidor via screen
screen -S mcs -p 0 -X stuff '/stop\n'

# Definir o tempo máximo de espera (timeout) em segundos
TIMEOUT=60
START_TIME=$(date +%s)

# Monitorar a saída do servidor para a mensagem de reinício
while true; do
    # Verificar se o servidor está em execução
    if ! screen -list | grep -q mcs; then
        echo "Servidor do Minecraft não está mais em execução."
        break
    fi

    # Verificar se a mensagem de reinício foi detectada
    if screen -S mcs -p 0 -X hardcopy /tmp/screenlog.0 && grep -q "Restarting automatically in 10 seconds" /tmp/screenlog.0; then
        echo "Mensagem de reinício detectada. Enviando sinal de interrupção (Ctrl+C) ao servidor..."
        screen -S mcs -p 0 -X stuff '\003'  # Envia Ctrl+C
        break
    fi

    # Verificar se o tempo de espera excedeu o timeout
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
        echo "Timeout atingido. Forçando o encerramento do servidor..."
        screen -S mcs -p 0 -X quit
        break
    fi

    # Aguardar 1 segundo antes de verificar novamente
    sleep 1
done

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
