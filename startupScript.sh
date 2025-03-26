
#!/bin/bash
#echo "Iniciando docker e containers"

#cd /root/InsightFullstackChallenge

#docker compose -f docker-compose-prod.yml up -d

echo "Iniciando o Servidor de Minecraft..."

# Navegar para o diretório do servidor
cd /home/kinbofox/github/serverMineATM || { echo "Falha ao acessar o diretório do servidor."; exit 1; }

# Ajustar as permissões para que todos os usuários tenham leitura, escrita e execução
chmod -R 777 /home/kinbofox/github/serverMineATM

# Configurar o Git local somente se for um repositório Git
if [ -d /home/kinbofox/github/serverMineATM/.git ]; then
    git config --local user.name "Juan Pimentel"
    git config --local user.email "juandbpimentel@gmail.com"
else
    echo "Repositório Git não encontrado em /home/kinbofox/github/serverMineATM; pulando configurações do Git."
fi

# Iniciar o servidor dentro de uma sessão screen chamada 'mcs'
echo "Iniciando o servidor dentro de uma sessão screen chamada 'mcs'..."
screen -d -m -S mcs ./startserver.sh

# Verificar se a sessão screen foi iniciada
if screen -list | grep -q mcs; then
    echo "Servidor iniciado com sucesso!"
else
    echo "Erro: O servidor não foi iniciado. Verifique o script startserver.sh."
fi
