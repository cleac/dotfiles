function _vpnsh_comp() {
    CUR="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(vpn.sh comp | paste -sd ' ' -)" -- "${CUR}") )
    return 0
}

function _rojsh_comp() {
    CUR="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(roj.sh --comp-list)" -- "${CUR}") )
    return 0
}

complete -F _rojsh_comp roj.sh
complete -F _vpnsh_comp vpn.sh
