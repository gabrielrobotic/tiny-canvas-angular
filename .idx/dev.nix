# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-25.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    # pkgs.go
    # pkgs.python311
    # pkgs.python311Packages.pip
    # pkgs.nodePackages.nodemon
    pkgs.zsh
    pkgs.nodejs_22
  ];
  # Sets environment variables in the workspace
  env = { };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # "vscodevim.vim"
      "google.gemini-cli-vscode-ide-companion"
      "bradlc.vscode-tailwindcss"
    ];
    # Enable previews
    previews = {
      enable = true;
      previews = {
        # web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
        #   command = ["npm" "run" "dev"];
        #   manager = "web";
        #   env = {
        #     # Environment variables to set for your server
        #     PORT = "$PORT";
        #   };
        # };
      };
    };
    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Example: install JS dependencies from NPM
        # npm-install = "npm install";
        # Open editors for the following files by default, if they exist:
        ohmyzsh-setup = ''
          echo "[onStart] Verificando Oh My Zsh..."

          export RUNZSH=no
          export CHSH=no

          OHMYZSH="$HOME/.oh-my-zsh"
          ZSHRC="$HOME/.zshrc"

          if [ ! -d "$OHMYZSH" ]; then
            echo "Oh My Zsh não encontrado. Instalando..."

            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

            echo "Configurando tema 'jonathan'..."
            sed -i 's/ZSH_THEME=".*"/ZSH_THEME="jonathan"/' "$ZSHRC"

            echo "Inserindo ZSH_DISABLE_COMPFIX=true..."
            sed -i '/^source \$ZSH\/oh-my-zsh.sh/i ZSH_DISABLE_COMPFIX=true' "$ZSHRC"

          else
            echo "Oh My Zsh já está instalado."

            # Garante que o tema esteja correto mesmo após updates
            grep -q 'ZSH_THEME="jonathan"' "$ZSHRC" || \
              sed -i 's/ZSH_THEME=".*"/ZSH_THEME="jonathan"/' "$ZSHRC"

            # Garante que o compfix esteja desabilitado
            grep -q 'ZSH_DISABLE_COMPFIX=true' "$ZSHRC" || \
              sed -i '/^source \$ZSH\/oh-my-zsh.sh/i ZSH_DISABLE_COMPFIX=true' "$ZSHRC"
          fi
        '';
        default.openFiles = [ ".idx/dev.nix" "README.md" ];
      };
      # Runs when the workspace is (re)started
      onStart = { };
    };
  };
}
