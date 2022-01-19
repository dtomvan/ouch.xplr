# ouch.xplr

This plugin uses `ouch` to compress and decompress files.

_WARNING_: Use version `0.3.1` of ouch. Older versions contain bugs
and newer versions are not (yet) supported by this plugin. If ouch
releases a new version I will try to update this to be compatible
with the new features.

```console
cargo install --git https://github.com/ouch-org/ouch --tag 0.3.1
```

## Requirements

- `ouch` (https://github.com/ouch-org/ouch)

## Installation

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  local home = os.getenv("HOME")
  package.path = home
  .. "/.config/xplr/plugins/?/init.lua;"
  .. home
  .. "/.config/xplr/plugins/?.lua;"
  .. package.path
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/dtomvan/ouch.xplr ~/.config/xplr/plugins/ouch
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("ouch").setup()

  -- Or

  require("ouch").setup{
    mode = "action",
    key = "o",
  }
  ```

## Features

- Wraps all features from the `ouch` tool:
  - `ouch decompress`
  - `ouch compress`
