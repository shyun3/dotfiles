mkdir -p ~/.local/state/logrotate
logrotate "${0:a:h}/nvim_lsp" --skip-state-lock --state ~/.local/state/logrotate/status
