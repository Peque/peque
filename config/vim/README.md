Install Vundle:

```
git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
```

Launch Neovim and run `:PluginInstall`.

YouCompleteMe is a plugin with a compiled component. Install the dependencies:

```
sudo dnf install cmake gcc-c++ make clang clang-tools-extra python3-devel rust cargo
```

Compile it with support for C-family languages and Rust:

```
pushd bundle/YouCompleteMe
python3 install.py --clang-completer --clang-tidy --rust-completer
popd
```
