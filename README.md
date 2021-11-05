ouch.xplr
====================
This plugin uses `ouch` to compress and decompress files.

*WARNING*: There is a problem in ouch with file formats, this plugin will not work entirely yet.

Tracking issue: https://github.com/ouch-org/ouch/issues/165

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
