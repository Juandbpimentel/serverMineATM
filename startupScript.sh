#!/bin/bash
echo "Iniciando o Servidor de Minecraft..."

# Caminho do servidor
SERVER_DIR="/home/kinbofox/github/serverMineATM"

# Navegar para o diretório do servidor
cd "$SERVER_DIR" || {
    echo "Erro: Diretório do servidor não encontrado em $SERVER_DIR."
    exit 1
}

# Ajustar as permissões para que os arquivos pertençam a 'kinbofox'
chown -R kinbofox:kinbofox "$SERVER_DIR"
chmod -R 644 "$SERVER_DIR"  # Define leitura/escrita para o dono (sem marcação de execução para arquivos)
# Permitir execução (acesso) em diretórios
find "$SERVER_DIR" -type d -exec chmod +x {} \;

# Configurar o Git local no repositório
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

# Iniciar o servidor usando screen no contexto do usuário kinbofox
echo "Iniciando o servidor dentro de uma sessão screen chamada 'mcs'..."
su - kinbofox -c "cd '$SERVER_DIR' && screen -d -m -S mcs ./startserver.sh"

# Verificar se a sessão screen foi iniciada
if screen -list | grep -q "mcs"; then
    echo "Servidor iniciado com sucesso!"
else
    echo "Erro: O servidor não foi iniciado. Verifique o script startserver.sh."
fi
