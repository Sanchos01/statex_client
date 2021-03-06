# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

	config :statex_client, 
		app: "my_great_appication", 
		host: "127.0.0.1",
		statex_server: "http://127.0.0.1:8888", # here we send data
		ttl: 3000, # interval for calling your callback
		memo_ttl: 3600000, # ttl for memorize json encoding and decoding
		callback_module: StatexClient, # module where is your callback
		hackney_opts: [timeout: 10000, hackney: [basic_auth: {"login","password"}]]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
