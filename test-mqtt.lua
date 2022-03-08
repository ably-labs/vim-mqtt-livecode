local mqtt = require('mqtt')


function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- please add $ABLY_API_KEY_LIVECODE to bashrc exports
local api_key = os.getenv("ABLY_API_KEY_LIVECODE")
local key_parts = Split(api_key, ":")
local username = key_parts[1]
local password = key_parts[2]

print(key_parts[1])
print(key_parts[2])

local client = mqtt.client({
  uri = "mqtt.ably.io",
  username = username,
  password = password,
  clean = true,
});


client:on{
  connect = function()
    print "Connected!"
    client:publish({
      topic = "hello",
      payload = "hello, world!",
      qos = 1,
    })

    client:subscribe({
      topic = "hello",
      qos = 1,
      callback = function(msg)
	print('received msg, ', msg)
      end
    })
  end,

  message = function()
    -- print "Message!"
  end,

  error = function(err)
    print("MQTT Error: ", err)
  end,
}

mqtt.run_ioloop(client)
