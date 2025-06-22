#!/bin/bash

#==============================================================================#
# Programa para personalização do vim.
# Finalidade 01 : Instala o VIM.
# Finalidade 02 : Altera o comportamento do VIM.
# Finalidade 03 : Altera o tema do VIM para (dracula_x).
#
# Versão : 2.0
#
# AUTOR   : LUCIANO PEREIRA DE SOUZA
# REVISOR : 
#
# Licença : GPL
#==============================================================================#

#==============================================================================#
# Arquivos de Configuração.
# ~/.vimrc
# 
# Arquivo de Tema.
# ~/.vim/colors/dracula_x.vim
#==============================================================================#


# Argumentos permitidos.
parametros=(-h --help -V --version -i --install -c --config -t --theme)

# Mensagem de ajuda.
mensagem_ajuda="
    USO : $(basename $0)\n\n
    -h, --help\n
    \tMostra esse painel de ajuda.\n
    -V --version\n
    \tMostra a versão do programa.\n
    -i --install\n
    \tInstala o VIM.\n
    -c --config\n
    \tConfigura o VIM, alterando o comportamento.\n
    -t --theme\n
    \tInstala o tema dracula.\n
"

# Versão do programa.
versao=$(grep "Versão" $0 | head -n1 | cut -d' ' -f2-)

# Coleta nome da distribuição.
distro=$(hostnamectl status | \
         grep -E "Operating System" | \
         cut -d: -f2 | \
         tr [A-Z] [a-z] | \
         cut -d' ' -f2)

# Distribuições.
distros=(debian linuxmint ubuntu fedora arch)

# Chaves.
ch_online=0

#=== Configurações do arquivo ~/.vimrc ===#
vimrc="
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
"
# colorscheme dracula_x \" Usa o tema dracula_x da pasta (~/.vim/colors).

#=== Cria o arquivo ~/.vim/colors/dracula_x.vim ===#
aplica_tema="colorscheme dracula_x"
configuracao_tema="
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

"

#=== Funções ===#
function verifica_internet() {
    local internet=$(ping -c2 google.com 2> /dev/null)
    if [ -z "$internet" ]; then
        return 0 # Sem internet ou sem DNS configurado!
    else
        return 1 # Com internet.
    fi
}

function instala_vim() {
    for i in ${distros[*]}; do
        if [ $i = $distro ]; then
            case $i in 
                "debian" | "linuxmint" | "ubuntu")
                    comando=$(sudo dpkg --get-selections | cut -f1 | \
                              grep -E "^vim$")
                    if [ $comando = "vim" ]; then
                        echo "Erro : VIM já está instalado."
                    else
                        sudo apt update
                        sudo apt install vim -y
                    fi
                ;;
                
                "fedora")
                    
                    if [ -f /usr/bin/vim ]; then
                        echo "Erro : VIM já está instalado."
                    else
                        sudo dnf update
                        sudo dnf install vim -y
                    fi
                ;;
                
                "arch")
                    comando=$(sudo pacman -Qq | grep -E "^vim$")
                    if [ $comando = "vim" ]; then
                        echo "Erro : VIM já está instalado."
                    else
                        sudo pacman -Sy
                        sudo pacman -S vim --noconfirm
                    fi
                ;;
                                
                *)
                    echo "Não é possivel instalar o VIM, tente manualmente."
                    exit 3
                    ;;
            esac
        fi
    done
}

function configuracao() {
    echo -e "$vimrc" > ~/.vimrc
    sed -i "/^$/d" ~/.vimrc

    if [ -f ~/.vim/colors/dracula_x.vim ]; then
        echo "colorscheme dracula_x" >> ~/.vimrc
    fi
    echo "Configurações aplicadas."
}

function instala_tema() {
    if [ -d ~/.vim/colors ]; then
        echo -e "$configuracao_tema" > ~/.vim/colors/dracula_x.vim
    else
        mkdir -p ~/.vim/colors
        echo -e "$configuracao_tema" > ~/.vim/colors/dracula_x.vim
    fi

    comando_grep=$(grep -E "^colorscheme dracula_x$" ~/.vimrc | wc -l)
    if [ $comando_grep -eq 0 ]; then
        echo -e "$aplica_tema" >> ~/.vimrc
    fi

    echo "Tema instalado!"
}

#=== Funções 2 ===#

# Case com 1 argumento.
function um_argumento() {
    case $1 in
        -h | --help)
            echo -e $mensagem_ajuda
        ;;
        
        -V | --version)
            echo $versao
        ;;
        
        -i | --install)
            verifica_internet ; ch_online=$?
            [ $ch_online -eq 1 ] && instala_vim || echo "Sem Internet!"
        ;;
        
        -c | --config)
            
            configuracao
        ;;

        -t | --theme)
            instala_tema
        ;;

    esac
}

# Coleta de argumentos.
function testa_argumentos() {
    argumentos=()

    for i in $*; do
        argumentos[${#argumentos[*]}]=$i
    done

    # Testa se os argumentos são válidos.
    argumentos_validos=0
    for a in ${argumentos[*]}; do
        for p in ${parametros[*]}; do
            if [ $a == $p ]; then
                argumentos_validos=$[$argumentos_validos + 1]
            fi
        done
    done

    # Testa se os argumentos são repetidos.
    argumentos_repetidos=0
    for a in ${argumentos[*]}; do
        for i in ${argumentos[*]}; do
            if [ $a = $i ]; then
                argumentos_repetidos=$[$argumentos_repetidos + 1]        
            fi
        done
        if [ $argumentos_repetidos -gt 1 ]; then
            echo "Argumentos repetidos!"
            exit 20
        fi
        argumentos_repetidos=0
    done

    # Testa a quantidade de argumentos válidos.
    if [ $argumentos_validos -eq ${#argumentos[*]} ]; then
        echo -n
    else
        if [ ${#argumentos[*]} -eq 1 ]; then
            echo "Argumento inválido!"
        else
            echo "Argumentos inválidos!"
        fi
        exit 10
    fi
}

# Case com 2 ou 3 argumentos.
function mais_argumentos() {
    argu_teste=()

    for i in $*; do
        argu_teste[${#argu_teste[*]}]=$i
    done

    for a in ${argu_teste[*]}; do
        for i in $(seq 0 3); do
            if [ $a = ${parametros[$i]} ]; then
                echo "Argumentos inválidos!"
                exit 50
            fi
        done
    done

    for a1 in ${argu_teste[*]}; do
        if [ $a1 = "-i" ]; then
            instala_vim
        fi
    done

    for a2 in ${argu_teste[*]}; do
        if [ $a2 = "-c" ]; then
            configuracao
        fi
    done

    for a3 in ${argu_teste[*]}; do
        if [ $a3 = "-t" ]; then
            instala_tema
        fi
    done

}


#=== Execução ===#
testa_argumentos $*


if [ $# -eq 0 ]; then
    echo -e $mensagem_ajuda
elif [ $# -eq 1 ]; then
    um_argumento $1
elif [ $# -gt 1 -a $# -lt 4 ]; then
    mais_argumentos $*
elif [ $# -gt 3 ]; then
    echo "Argumentos em excesso!"
fi
