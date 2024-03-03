echo 'export PATH=$PATH:$HOME/.local/bin' >> $HOME/.bashrc
python -m pip install -e .[dev,docs,test,notebooks]