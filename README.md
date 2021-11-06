ouch.xplr
====================
This plugin uses `ouch` to compress and decompress files.

*WARNING*: Use version `0.3.1` of ouch. Older versions contain bugs
and newer versions are not (yet) supported by this plugin. If ouch
releases a new version I will try to update this to be compatible
with the new features.
```console
cargo install --git https://github.com/ouch-org/ouch --tag 0.3.1
```

Requirements
------------

- `ouch` (https://github.com/ouch-org/ouch)


Installation
------------

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  package.path = os.getenv("HOME") .. '/.config/xplr/plugins/?/src/init.lua'
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


Features
--------

- Wraps all features from the `ouch` tool:
    - `ouch decompress`
    - `ouch compress`
