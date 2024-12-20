Install vim-plug:

https://github.com/junegunn/vim-plug

Launch Neovim and run `:PlugInstall`.

YouCompleteMe is a plugin with a compiled component. Install the dependencies:

```
toolbox enter neovim
sudo dnf install neovim
sudo dnf install cmake gcc-c++ make clang clang-tools-extra python3-devel rust cargo
```

Compile it with support for C-family languages and Rust:

```
pushd ~/.local/share/nvim/plugged/YouCompleteMe/
conda activate python39
pip install --upgrade pynvim
python install.py --clang-completer --clang-tidy --rust-completer --js-completer --ts-completer
popd
```
