root@ubuntu:~/distributed-si-crypto-arbitrage/main_app# cat run_production.sh
iex --name none@127.0.0.1 --cookie TESTING & mix run -e "Core.Initializer.init_all()"