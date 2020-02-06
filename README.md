# install-zabbix-agent.sh

This is a tiny little bash script to install zabbix-agent and create the configurations needed.

It creates:

* PSK-Identity and PSK-Key
* /etc/zabbix-agent/zabbix_agentd.conf

## Dependencies

As I'm using this or a similar script on all my servers I've just tested this against software that I use.

* Debian Buster (10)
* Debian Jessie (9)
* Debian Stretch (8)

## Usage

Just run the script directly (please, for gods sake - check the code prior to execution):

```
bash <(curl -s https://raw.githubusercontent.com/dominicpratt/install-zabbix-agent/master/install-zabbix-agent.sh)
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
