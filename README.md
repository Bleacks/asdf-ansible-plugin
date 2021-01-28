<div align="center">

# asdf-ansible ![Build](https://github.com/Bleacks/asdf-ansible/workflows/Build/badge.svg) ![Lint](https://github.com/Bleacks/asdf-ansible/workflows/Lint/badge.svg)

[ansible](https://github.com/Bleacks/asdf-ansible-plugin) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add ansible
# or
asdf plugin add https://github.com/Bleacks/asdf-ansible.git
```

ansible:

```shell
# Show all installable versions
asdf list-all ansible

# Install specific version
asdf install ansible latest

# Set a version globally (on your ~/.tool-versions file)
asdf global ansible latest

# Now ansible commands are available
ansible --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Bleacks/asdf-ansible/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Bleacks](https://github.com/Bleacks/)
