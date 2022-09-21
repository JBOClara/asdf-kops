<div align="center">

# asdf-kops [![Build](https://github.com/JBOClara/asdf-kops/actions/workflows/build.yml/badge.svg)](https://github.com/JBOClara/asdf-kops/actions/workflows/build.yml) [![Lint](https://github.com/JBOClara/asdf-kops/actions/workflows/lint.yml/badge.svg)](https://github.com/JBOClara/asdf-kops/actions/workflows/lint.yml)


[kops](https://kops.sigs.k8s.io) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `ASDF_KOPS_OVERWRITE_ARCH`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add kops
# or
asdf plugin add kops https://github.com/JBOClara/asdf-kops.git
```

kops:

```shell
# Show all installable versions
asdf list-all kops

# Install specific version
asdf install kops latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kops latest

# Now kops commands are available
kops version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/JBOClara/asdf-kops/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [JBOClara](https://github.com/kubernetes/)
