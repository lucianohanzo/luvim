#!/bin/bash

# Testa se tem internet.
Internet=$(ping google.com -c1 2> /dev/null)
if [ ! "$Internet" ]
then
    clear && echo "Não tem internet, ou sem DNS."
    exit 2
fi
#==================================================

# Verifica se o "Vim" está instalado.
InstaVim=$(dpkg -l | grep "ii  vim" | head -n1 |
	    tr -s "  " " " | cut -f2 -d" " | grep "^vim$")
if [ ! "$InstaVim" ]
then
    clear && echo "Vim não está instalado!"
    echo "Deseja instalar o vim?"
    echo -e "1 - Instalar o Vim\n* - não instalar"
    
    read -p "Qual a sua escolha : " Escolha1
    if [ $Escolha1 = 1 ]
    then
        clear && apt install -y vim
	clear && echo "Vim instalado!" && sleep 4
    else
	clear && echo "Sayonara!"
	exit 3
    fi

fi
#==================================================

# Verifica se o "Git" está instalado.
InstaGit=$(dpkg -l | grep "ii  git" | head -n1 |
           tr -s "  " " " | cut -f2 -d" " | grep "^git$")
if [ ! "$InstaGit" ]
then
    clear && echo "Git não está instalado!"
    echo "Deseja instalar o git?"
    echo -e "1 - Instalar o Git\n* - não instalar"
    
    read -p "Qual a sua escolha : " Escolha2
    if [ $Escolha2 = 1 ]
    then
        clear && apt install -y git
	clear && echo "Git instalado!" && sleep 4
    else
	clear && echo "Sayonara!"
	exit 3
    fi

fi
#==================================================

# Criar arquivo de configuração vim.
> ~/.vimrc

#=== Cria pasta de configuração de temas. ===#
    # Obtem a versão do vim.
Versao=$(vim --version | head -n1 | cut -f5 -d" ")
    # Retorna "1" caso a versão do vim seja maior que 8.2.
Teste=$(echo "$Versao >= 8.2" | bc -l)

# Instala a pasta dependendo da condição.
if [ $Teste -ge 1 ]
then
    if [ ! -d ~/.vim/pack/themes/start/dracula ]
    then
        mkdir -p ~/.vim/pack/themes/start
        git clone https://github.com/dracula/vim.git \
	        ~/.vim/pack/themes/start/dracula 2> /dev/null
    fi
else
    if [ ! -d ~/.vim/pack/themes/opt/dracula ]
    then
        mkdir -p ~/.vim/pack/themes/start
        git clone https://github.com/dracula/vim.git \
	        ~/.vim/pack/themes/opt/dracula 2> /dev/null
    fi
fi
#==================================================

# Coloca informações no arquivo '.vimrc', mudando o padrão do Vim.
echo '
set tabstop=4        " tabulação com 4 espaços.
set expandtab        " Troca tabulação por espaços.
filetype on          " Tenta detectar o tipo de arquivo.
" filetype indent on " Identação automatica.
syntax on            " Ativar o realce de sintaxe.
set number           " Numera as linhas.
set cursorline       " Deixa detacado a linha corespondente.
set nowrap           " Não quebrar linhas.
colorscheme dracula  " Coloca o tema dracula baixado na pasta (~/.vim/pack/themes/start)
set colorcolumn=80' > ~/.vimrc
#==================================================

# Mensagem final.
clear && echo "Configurações do Vim aplicadas!"

# Fim do script
