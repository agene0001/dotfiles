sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm ./google-chrome-stable_current_amd64.deb
sudo apt-get install burpsuite
sudo wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz
sudo tar -xvzf postman-linux-x64.tar.gz -C /opt 
sudo ln -s /opt/Postman/Postman /usr/bin/postman 
rm ./postman-linux-x64.tar.gz
sudo apt-get install amass
git clone https://github.com/assetnote/kiterunner.git
cd kiterunner
make build
sudo ln -s $(pwd)/dist/kr /usr/local/bin/kr
cd ~
mkdir -p ~/api/wordlists
curl https://wordlists-cdn.assetnote.io/data/automated/httparchive_apiroutes_2021_06_28.txt > ~/api/wordlists/latest_api_wordlist.txt
sudo apt install zaproxy
pipx install arjun
sudo apt install seclists
sudo apt install gdb
