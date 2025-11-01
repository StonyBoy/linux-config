-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Nov-01 14:43
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  cmd = { "docker-langserver", "start", "--stdio" },
  filetypes = { "dockerfile", "yaml.docker-compose" },
  root_markers = { "Dockerfile", "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml", "docker-bake.json", "docker-bake.hcl", "docker-bake.override.json", "docker-bake.override.hcl" },
}

