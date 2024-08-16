#!/bin/bash

#=== Boas Vindas ===#
clear && echo -e "Bem vindo ao instalador \"luvim.sh\".\n" && sleep 5
clear

#=== Verifica se tem internet. ===#
Internet=$(ping -c1 google.com > /dev/null 2> /dev/null)

if [ "$Internet" ]; then
    echo "Não tem Internet ou sem DNS configurado!"
    exit 1
fi
#===============================================================================

#=== Verifica se o VIM está instalado ===#
InstaVim=$(dpkg -l | grep "ii  vim" | tr -s "  " " " |
           cut -d" " -f2 | grep "^vim$")

if [ ! "$InstaVim" ]; then
    Bandeira=1
    while [ $Bandeira -eq 1 ]; do
        clear && echo -e "VIM não está instalado!\n" && sleep 2
        echo "Deseja instalar o VIM?"
        echo -e "1 - Sim\n2 - Não"
        read -p "Qual sua resposta : " Resposta
        if [ "$Resposta" -eq 1 ]; then
            clear && echo "Instalado o \"VIM\"..." && sleep 3 && clear
            sudo apt install -y vim 2&> /dev/null
            InstaVim=$(dpkg --get-selections | tr -s "\t" | cut -f1 | grep vim$)
            if [ "$InstaVim" != "vim" ]; then
                clear
                echo "O VIM não foi instalado, atualize os repositórios! \"DPKG\""
                sleep 5 && clear && exit 2
            else
                clear && echo "VIM, instalado com sucesso!" && sleep 4
            fi
            Bandeira=0
        elif [ "$Resposta" -eq 2 ]; then
            clear && echo "Saindo do \"luvim.sh\"..." && sleep 4 && clear
            Bandeira=0
        else
            clear && echo "Resposta Inválida!" && sleep 4
        fi
    done
fi
#===============================================================================

#=== Cria o arquivo ~/.vimrc e os diretórios do VIM. ===#
clear && echo "Criando arquivos e diretórios do VIM..." && sleep 4 && clear

> ~/.vimrc # Cria arquivo ".vimrc".
mkdir -p ~/.vim/colors/ # Cria o diretório "~/.vim/colors/".
> ~/.vim/colors/dracula_x.vim # Cria o arquivo "dracula_x.vim".
#===============================================================================

#=== Edita o arquivo ~/.vim/colors/dracula_x.vim ===#
echo "
set background=dark

hi clear

\" Cor de fundo
hi Normal guifg=NONE guibg=#282a36 gui=NONE cterm=NONE

\" Cor da linha da coluna vertical.
hi ColorColumn guifg=NONE guibg=#2f313d gui=NONE cterm=NONE
  
\" Valore Boleanos como true e false
hi Boolean guifg=#707df9 guibg=NONE gui=NONE cterm=NONE

\" Número da linha.
hi LineNr guifg=#6272a4 guibg=#282a36 gui=NONE cterm=NONE

\" Comentários
hi Comment guifg=#5e71a4 guibg=NONE gui=NONE cterm=NONE

\" Alguns comandos especiais do linux e comandos com \ em outras linguagens.
hi Special guifg=#ff78a1 guibg=NONE gui=NONE cterm=NONE

\" Tipos como int, bool, double...
hi Type guifg=#d056b5 guibg=NONE gui=NONE cterm=NONE

\" Linha do cursor.
hi CursorLine guifg=NONE guibg=#21232f gui=NONE cterm=NONE

\" Linha do cursor do número da linha.
hi CursorLineNr guifg=NONE guibg=#21232f gui=NONE cterm=NONE

\" Nome dos links em HTML
hi Underlined guifg=#ffffff guibg=NONE gui=NONE cterm=NONE

\" Instruções ou declarações como if,else entre outros. IMPORTANTE!
hi Statement guifg=#ff79c6 guibg=NONE gui=NONE cterm=NONE

\" Strings, números entre outros. IMPORTANTE!
hi Constant guifg=#ffff85 guibg=NONE gui=NONE cterm=NONE

\" Identicadores, sinal de < > em HTML, True e False em python. IMPORTANTE!
hi Identifier guifg=#ffffff guibg=NONE gui=NONE cterm=italic

\" Pré Processamento.
hi PreProc guifg=#ff79c6 guibg=NONE gui=NONE cterm=NONE

\" Títulos e Sub-Títulos do HTML
hi Title guifg=#ffffff guibg=NONE gui=NONE cterm=NONE

\" Cores de alteração dos modos do VIM.
hi ModeMsg guifg=#ffacff guibg=#484848 gui=NONE cterm=bold

\" Sintaxe de erros do VIM.
hi Error guifg=#ff2000 guibg=NONE gui=NONE cterm=underline

\" Modo de visualização do VIM 
hi Visual guifg=NONE guibg=#353744 gui=NONE cterm=italic

" > ~/.vim/colors/dracula_x.vim

#===============================================================================

#=== Edita o arquivo ~/.vimrc ===#
echo "
set tabstop=4         \" tabulação com 4 espaços.

set expandtab         \" Troca tabulação por espaços.

filetype on           \" Tenta detectar o tipo de arquivo.

\" filetype indent on  \" Identação automatica.

syntax on             \" Ativar o realce de sintaxe.

set number            \" Numera as linhas.

set cursorline        \" Deixa destacado a linha corespondente.

set nowrap            \" Não quebrar linhas.

set colorcolumn=80    \" Coluna vertical no caractere 80

set termguicolors     \" Aceita esquema de cores em hexadecimal.

colorscheme dracula_x \" Usa o tema dracula_x da pasta (~/.vim/colors).
" > ~/.vimrc # Envia todas essas informações para o arquivo ~/.vimrc
clear && echo "Arquivos e diretórios criados!" && sleep 4 && clear
#===============================================================================

echo "Instalação finalizada!" && echo -e "\n"
read -p "Aperte \"Enter\" para finaliza! " && clear

# Fim do script.
