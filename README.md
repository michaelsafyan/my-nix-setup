# my-nix-setup
Customized BASH profile and various small utility scripts that I use to be more productive.

## Installation instructions

To install, use the following command on the commandline:

    curl "https://raw.githubusercontent.com/michaelsafyan/my-nix-setup/master/setup.sh" | bash
    
## Extending
The BASH configuration that this installs automatically loads:

    # When loading ~/.bashrc and when loading ~/.profile
    ~/.local/etc/bashrc.sh
    ~/.local/etc/bashrc.d/*.sh
    ~/.local/platform/<platform>/etc/bashrc.sh
    ~/.local/platform/<platform>/etc/bashrc.d/*.sh
    # When loading ~/.profile
    ~/.local/etc/profile.sh
    ~/.local/etc/profile.d/*.sh
    ~/.local/platform/<platform>/etc/profile.sh
    ~/.local/platform/<platform>/etc/profile.d/*.sh
   
In addition, it automatically adds the following directory to the PATH:

    ~/.local/bin
    ~/.local/platform/<platform>/bin
   
This can be used to supplement the configuration and utilities provided by this package. In the above, "&lt;platform&gt;" would be replaced with something like "linux", "macosx", "ubuntu-trusty", etc. This makes it possible to have a single consistent configuration synced across different devices, where platform-specific utilities get loaded/invoked only on the platform for which that platform-specific configuration is applicable.

## Features and utilities
In addition to setting up reasonable default paths, colorizing the prompt, etc. my-nix-setup also provides a number of [handy utility scripts](https://github.com/michaelsafyan/my-nix-setup/tree/master/my-nix-setup/bin). The [log](https://github.com/michaelsafyan/my-nix-setup/blob/master/my-nix-setup/bin/log) and [require_arg_count](https://github.com/michaelsafyan/my-nix-setup/blob/master/my-nix-setup/bin/require_arg_count) scripts in particular are extremely handy as building blocks in other scripts.

## Contributing
Because this project is primarily about my own productivity (and making it easy to sync down my personal configuration between devices), there are certain changes that I might not be willing to accept. However, I would be more than happy to accept bug fixes. And, if you do fork this repository and add some awesome new feature for your own version, please do let me know about it... if it's handy enough, there is some chance that it will make it back into here.
