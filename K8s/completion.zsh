# Enable kubectl auto completion
if [[ -x "$(command -v kubectl)" ]]; then
	source <(kubectl completion zsh)
fi

# /opt/homebrew/Cellar/eksctl/0.203.0/bin/
# If eksctl is inste

if [[ -x "$(command -v eksctl)" ]]; then
	source <(eksctl completion zsh)
fi
