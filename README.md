StatexClient
============

Client for statex server. First, you should write config

```
config :statex_client, 
	app: "my_great_appication", 
	host: "127.0.0.1",
	statex_server: "http://127.0.0.1:8888", # here we send data
	ttl: 1000, # interval for calling your callback
	memo_ttl: 3600000, # ttl for memorize json encoding and decoding
	callback_module: StatexClient, # module where is your callback
	hackney_opts: [timeout: 10000, hackney: [basic_auth: {"login","password"}]]
```

second, you should write callback in your callback_module, that should return %StatexClient.Info{} struct with your info

```
def statex_callback, do: %StatexClient.Info{ok: true}
```

if some event happened, and you wanna to report it to statex server, you can execute in your code

```
StatexClient.send(mess = %StatexClient.Info{}) # returns :ok | {:error, error}
```

Description of %StatexClient.Info{} :

```
%StatexClient.Info{
	ok: false, # boolean state of your application
    info: "", # binary, some message, for example "application init!"
    data: nil # some statistics data, for example number of requests per sec
}
```

enjoy!