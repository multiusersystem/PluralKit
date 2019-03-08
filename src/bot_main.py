import asyncio
import json
import os
import sys

try:
    # uvloop doesn't work on Windows, therefore an optional dependency
    import uvloop
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())
except ImportError:
    pass

with open(sys.argv[1] if len(sys.argv) > 1 else "pluralkit.conf") as f:
    config = json.load(f)

if "database_uri" not in config and "DATABASE_URI" not in os.environ:
    print("Config file must contain key 'database_uri', or the environment variable DATABASE_URI must be present.")
elif "token" not in config and "TOKEN" not in os.environ:
    print("Config file must contain key 'token', or the environment variable TOKEN must be present.")
else:
    from pluralkit import bot
    bot.run(os.environ.get("TOKEN", config.get("token")), os.environ.get("DATABASE_URI", config.get("database_uri"), int(config.get("log_channel", 0)))