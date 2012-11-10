# Simple Elixir Version Management: exenv

exenv lets you easily switch between multiple versions of Elixir. It's
simple, unobtrusive, and follows the UNIX tradition of single-purpose
tools that do one thing well.

exenv is a Elixir version of rbenv and used denv as a reference.
Thanks to @sstephenson and @repeatedly.

### exenv _does…_

* Let you **change the global Elixir version** on a per-user basis.
* Provide support for **per-project Elixir versions**.
* Allow you to **override the Elixir version** with an environment
  variable.

## Table of Contents

   * [1 How It Works](#section_1)
   * [2 Installation](#section_2)
      * [2.1 Basic GitHub Checkout](#section_2.1)
         * [2.1.1 Upgrading](#section_2.1.1)
      * [2.2 Neckbeard Configuration](#section_2.2)
   * [3 Usage](#section_3)
      * [3.1 exenv global](#section_3.1)
      * [3.2 exenv local](#section_3.2)
      * [3.3 exenv shell](#section_3.3)
      * [3.4 exenv versions](#section_3.4)
      * [3.5 exenv version](#section_3.5)
      * [3.6 exenv rehash](#section_3.6)
      * [3.7 exenv which](#section_3.7)
   * [4 Development](#section_4)
      * [4.1 Version History](#section_4.1)
      * [4.2 License](#section_4.2)

## <a name="section_1"></a> 1 How It Works

exenv operates on the per-user directory `~/.exenv`. Version names in
exenv correspond to subdirectories of `~/.exenv/versions`. For
example, you might have `~/.exenv/versions/0.6.0` and
`~/.exenv/versions/0.7.0`.

Each version is a working tree with its own binaries, like
`~/.exenv/versions/0.6.0/bin/elixir` and
`~/.exenv/versions/0.7.0/bin/iex`. exenv makes _shim binaries_
for every such binary across all installed versions of Elixir.

These shims are simple wrapper scripts that live in `~/.exenv/shims`
and detect which Elixir version you want to use. They insert the
directory for the selected version at the beginning of your `$PATH`
and then execute the corresponding binary.

Because of the simplicity of the shim approach, all you need to use
exenv is `~/.exenv/shims` in your `$PATH`.

## <a name="section_2"></a> 2 Installation

### <a name="section_2.1"></a> 2.1 Basic GitHub Checkout

This will get you going with the latest version of exenv and make it
easy to fork and contribute any changes back upstream.

1. Check out exenv into `~/.exenv`.

        $ cd
        $ git clone git://github.com/mururu/exenv.git .exenv

2. Add `~/.exenv/bin` to your `$PATH` for access to the `exenv`
   command-line utility.

        $ echo 'export PATH="$HOME/.exenv/bin:$PATH"' >> ~/.bash_profile

    **Zsh note**: Modify your `~/.zshenv` file instead of `~/.bash_profile`.

3. Add exenv init to your shell to enable shims and autocompletion.

        $ echo 'eval "$(exenv init -)"' >> ~/.bash_profile

    **Zsh note**: Modify your `~/.zshenv` file instead of `~/.bash_profile`.

4. Restart your shell so the path changes take effect. You can now
   begin using exenv.

        $ exec $SHELL

5. Install Elixir versions into `~/.exenv/versions`. For example, to
   install Elixir 0.7.0, download and unpack the source, then run:

        $ wget https://github.com/downloads/elixir-lang/elixir/v0.7.0.zip
        $ unzip v0.7.0.zip -d v0.7.0
        $ mv v0.7.0 ~/.exenv/versions/0.7.0

6. Rebuild the shim binaries. You should do this any time you install
   a new Elixir binary (for example, when installing a new Elixir version,
   or when installing a gem that provides a binary).

        $ exenv rehash

#### <a name="section_2.1.1"></a> 2.1.1 Upgrading

If you've installed exenv using the instructions above, you can
upgrade your installation at any time using git.

To upgrade to the latest development version of exenv, use `git pull`:

    $ cd ~/.exenv
    $ git pull

To upgrade to a specific release of exenv, check out the corresponding
tag:

    $ cd ~/.exenv
    $ git fetch
    $ git tag
    v0.1.0
    v0.1.1
    v0.1.2
    v0.2.0
    $ git checkout v0.2.0

### <a name="section_2.2"></a> 2.2 Neckbeard Configuration

Skip this section unless you must know what every line in your shell
profile is doing.

`exenv init` is the only command that crosses the line of loading
extra commands into your shell. Coming from rvm, some of you might be
opposed to this idea. Here's what `exenv init` actually does:

1. Sets up your shims path. This is the only requirement for exenv to
   function properly. You can do this by hand by prepending
   `~/.exenv/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty
   useful. Sourcing `~/.exenv/completions/exenv.bash` will set that
   up. There is also a `~/.exenv/completions/exenv.zsh` for Zsh
   users.

3. Rehashes shims. From time to time you'll need to rebuild your
   shim files. Doing this on init makes sure everything is up to
   date. You can always run `exenv rehash` manually.

4. Installs the sh dispatcher. This bit is also optional, but allows
   exenv and plugins to change variables in your current shell, making
   commands like `exenv shell` possible. The sh dispatcher doesn't do
   anything crazy like override `cd` or hack your shell prompt, but if
   for some reason you need `exenv` to be a real script rather than a
   shell function, you can safely skip it.

Run `exenv init -` for yourself to see exactly what happens under the
hood.

## <a name="section_3"></a> 3 Usage

Like `git`, the `exenv` command delegates to subcommands based on its
first argument. The most common subcommands are:

### <a name="section_3.1"></a> 3.1 exenv global

Sets the global version of Elixir to be used in all shells by writing
the version name to the `~/.exenv/version` file. This version can be
overridden by a per-project `.exenv-version` file, or by setting the
`exenv_VERSION` environment variable.

    $ exenv global 0.7.0

The special version name `system` tells exenv to use the system Elixir
(detected by searching your `$PATH`).

When run without a version number, `exenv global` reports the
currently configured global version.

### <a name="section_3.2"></a> 3.2 exenv local

Sets a local per-project Elixir version by writing the version name to
an `.exenv-version` file in the current directory. This version
overrides the global, and can be overridden itself by setting the
`exenv_VERSION` environment variable or with the `exenv shell`
command.

    $ exenv local 0.6.0

When run without a version number, `exenv local` reports the currently
configured local version. You can also unset the local version:

    $ exenv local --unset

### <a name="section_3.3"></a> 3.3 exenv shell

Sets a shell-specific Elixir version by setting the `exenv_VERSION`
environment variable in your shell. This version overrides both
project-specific versions and the global version.

    $ exenv shell 0.7.0

When run without a version number, `exenv shell` reports the current
value of `exenv_VERSION`. You can also unset the shell version:

    $ exenv shell --unset

Note that you'll need exenv's shell integration enabled (step 3 of
the installation instructions) in order to use this command. If you
prefer not to use shell integration, you may simply set the
`exenv_VERSION` variable yourself:

    $ export exenv_VERSION=0.6.0

### <a name="section_3.4"></a> 3.4 exenv versions

Lists all Elixir versions known to exenv, and shows an asterisk next to
the currently active version.

    $ exenv versions
      0.5.0
    * 0.6.0
      0.7.0

### <a name="section_3.5"></a> 3.5 exenv version

Displays the currently active Elixir version, along with information on
how it was set.

    $ exenv version
    0.7.0 (set by /Volumes/37signals/basecamp/.exenv-version)

### <a name="section_3.6"></a> 3.6 exenv rehash

Installs shims for all Elixir binaries known to exenv (i.e.,
`~/.exenv/versions/*/bin/*`). Run this command after you install a new
version of Elixir.

    $ exenv rehash

### <a name="section_3.7"></a> 3.7 exenv which

Displays the full path to the binary that exenv will execute when you
run the given command.

    $ exenv which iex
    /Users/sam/.exenv/versions/0.7.0/bin/iex

## <a name="section_4"></a> 4 Development

The exenv source code is [hosted on
GitHub](https://github.com/mururu/exenv). It's clean, modular,
and easy to understand, even if you're not a shell hacker.

Please feel free to submit pull requests and file bugs on the [issue
tracker](https://github.com/mururu/exmarkdown/issues).

### <a name="section_4.1"></a> 4.1 Version History

**0.1.0** (November 10, 2012)

Fork [rbenv](https://github.com/sstephenson/rbenv)

### <a name="section_4.2"></a> 4.2 License

(The MIT license)

Copyright (c) 2011 Sam Stephenson, Yuki Ito

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
