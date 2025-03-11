mkdir -p ~/.local/state/logrotate
logrotate "${0:a:h}/nvim_lsp" --state ~/.local/state/logrotate/status
