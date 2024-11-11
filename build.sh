# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod PHX_HOST=0.0.0.0 mix phx.gen.release --docker

# clean up
mix phx.digest.clean --all