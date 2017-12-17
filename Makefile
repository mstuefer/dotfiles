
# TODO
# iTerm2 ? (Set homebrew bash as default shell)
# pip3 install neovim

all:
	[ -f ~/.config/nvim/init.vim ] 		|| mkdir -p ~/.config/nvim/ && ln -s $(PWD)/vimrc ~/.config/nvim/init.vim
	[ -f ~/.ctags ] 			|| ln -s $(PWD)/ctags ~/.ctags
	[ -f ~/.bashrc ] 			|| ln -s $(PWD)/bashrc ~/.bashrc
	[ -f ~/.bash_profile ] 			|| ln -s $(PWD)/bashrc ~/.bash_profile
	[ -f ~/.tigrc ] 			|| ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/Brewfile ] 			|| ln -s $(PWD)/Brewfile ~/Brewfile
	[ -f ~/.git-completion.bash ]		|| ln -s $(PWD)/git-completion.bash ~/.git-completion.bash
	[ -f ~/.git-prompt.sh ]			|| ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	[ -f ~/.gitconfig ]			|| ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.agignore ] 			|| ln -s $(PWD)/agignore ~/.agignore
	[ -h ~/.vim ]				|| ln -s ~/.config/nvim/ ~/.vim
	[ -f ~/.vimrc ]				|| ln -s ~/.config/nvim/init.vim ~/.vimrc
	[ -f ~/.tmux.conf ]			|| ln -s $(PWD)/tmuxconf ~/.tmux.conf
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

clean:
	([ ! -f ~/.vimrc ] && [ ! -h ~/.vimrc ])				|| rm -rf ~/.vimrc
	([ ! -f ~/.ctags ] && [ ! -h ~/.ctags ])				|| rm -rf ~/.ctags
	([ ! -f ~/.bashrc ] && [ ! -h ~/.bashrc ]) 				|| rm -rf ~/.bashrc
	([ ! -f ~/.bash_profile ] && [ ! -h ~/.bash_profile ])			|| rm -rf ~/.bash_profile
	([ ! -f ~/.tigrc ] && [ ! -h ~/.tigrc ]) 				|| rm -rf ~/.tigrc
	([ ! -f ~/.Brewfile ] && [ ! -h ~/.Brewfile ]) 				|| rm -rf ~/.Brewfile
	([ ! -f ~/Brewfile ] && [ ! -h ~/Brewfile ]) 				|| rm -rf ~/Brewfile
	([ ! -f ~/.git-completion.sh ] && [ ! -h ~/.git-completion.sh ])	|| rm -rf ~/.git-completion.sh
	([ ! -f ~/.git-completion.bash ] && [ ! -h ~/.git-completion.bash ])	|| rm -rf ~/.git-completion.bash
	([ ! -f ~/.git-prompt.sh ] && [ ! -h ~/.git-prompt.sh ])		|| rm -rf ~/.git-prompt.sh
	([ ! -f ~/.gitconfig ] && [ ! -h ~/.gitconfig ])			|| rm -rf ~/.gitconfig
	([ ! -f ~/.agignore ] && [ ! -h ~/.agignore ]) 				|| rm -rf ~/.agignore
	([ ! -d ~/.config/nvim/ ] && [ ! -h ~/.config/nvim ])			|| rm -rf ~/.config/nvim
	([ ! -d ~/.vim/ ] && [ ! -h ~/.vim ])					|| rm -rf ~/.vim
	([ ! -f ~/.tmux.conf ] && [ ! -h ~/.tmux.conf ])			|| rm -rf ~/.tmux.conf

