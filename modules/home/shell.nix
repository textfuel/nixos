{ config, lib, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  services.ssh-agent.enable = true;

  xdg.configFile."p10k/p10k.zsh".source = ./p10k.zsh;

  programs.zsh = {
    enable = true;
    shellAliases = {
      dedup = "sudo duperemove -dr --io-threads=$(nproc) --hashfile=/var/cache/duperemove.db /";
      lz = "lazygit";
      q = "exit";
      nv = "nvim";
      cl = "claude --dangerously-skip-permissions";
      ls = "ls --color=force";
      l = "ls -a";
      sw = "stow";
    };
    history = {
      size = 5000;
      save = 5000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };
    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        # Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkOrder 1000 ''
        source ${pkgs.zinit}/share/zinit/zinit.zsh

        # Prompt
        zinit ice depth=1; zinit light romkatv/powerlevel10k

        # Plugins
        zinit light zsh-users/zsh-syntax-highlighting
        zinit ice wait lucid blockf atpull'zinit creinstall -q .'
        zinit light zsh-users/zsh-completions
        zinit light zsh-users/zsh-autosuggestions
        zinit light Aloxaf/fzf-tab
        zinit light nix-community/nix-zsh-completions

        # OMZ snippets
        zinit snippet OMZL::git.zsh
        zinit snippet OMZP::git
        zinit snippet OMZP::command-not-found
        zinit snippet OMZP::aliases
        zinit snippet OMZP::colorize

        # Completion
        autoload -U compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':completion:*' verbose yes
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*:messages' format '%d'
        zstyle ':completion:*:warnings' format 'No matches'
        zstyle ':completion:*' group-name '''
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:*' switch-group '<' '>'

        # NixOS rebuild
        nrs() {
          nh os switch ~/nixos
          fsel --refresh-cache
        }

        nrsf() {
          nix flake update --flake ~/nixos && nrs
        }

        # Local bin
        path+=("$HOME/.local/bin")

        # Emacs keybinds
        bindkey -e

        # Shell integrations
        eval "$(fzf --zsh)"
        eval "$(zoxide init zsh)"

        # p10k config
        source ~/.config/p10k/p10k.zsh
      '')
    ];
  };
}
