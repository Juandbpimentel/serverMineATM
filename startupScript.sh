#!/bin/bash
echo "Iniciando o Servidor de Minecraft..."

# Navegar para o diretório do servidor
cd /home/kinbofox/github/serverMineATM || {
    echo "Erro: Diretório do servidor não encontrado em /home/kinbofox/github/serverMineATM."
    exit 1
}

# Ajustar as permissões para que os arquivos pertençam a 'kinbofox'
chown -R kinbofox:kinbofox /home/kinbofox/github/serverMineATM
chmod -R 644 /home/kinbofox/github/serverMineATM  # Define leitura/escrita para o dono (sem marcação de execução para arquivos)
# Permitir execução (acesso) em diretórios
find /home/kinbofox/github/serverMineATM -type d -exec chmod +x {} \;

# Configurar o Git local somente se for um repositório Git
if [ -d /home/kinbofox/github/serverMineATM/.git ]; then
    if ! git config --local core.fileMode &>/dev/null; then
        echo "Configurando core.fileMode para ignorar alterações de permissões..."
        git config --local core.fileMode false
    fi

    if ! git config --local user.name &>/dev/null; then
        echo "Configurando usuário local do Git..."
        git config --local user.name "Juan Pimentel"
    fi

    if ! git config --local user.email &>/dev/null; then
        echo "Configurando e-mail local do Git..."
        git config --local user.email "juandbpimentel@gmail.com"
    fi
else
    echo "Repositório Git não encontrado em /home/kinbofox/github/serverMineATM; pulando configurações do Git."
fi

# Iniciar o servidor usando screen no contexto do usuário 'kinbofox'
echo "Iniciando o servidor dentro de uma sessão screen chamada 'mcs'..."
su - kinbofox -c "cd /home/kinbofox/github/serverMineATM && screen -d -m -S mcs ./startserver.sh"

# Verificar se a sessão screen foi iniciada (executa o comando no contexto do usuário 'kinbofox')
if su - kinbofox -c "screen -list | grep -q mcs"; then
    echo "Servidor iniciado com sucesso!"
else
    echo "Erro: O servidor não foi iniciado. Verifique o script startserver.sh."
fi
