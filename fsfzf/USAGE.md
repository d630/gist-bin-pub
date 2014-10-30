In an interactive shell without alias or configured sourcing in your bash configs:

```bash
$ source fsfzf.sh <DIR>
$ source fsfzf.sh ~/ # tilde expansions
$ source fsfzf.sh .
$ source fsfzf.sh bin/ # programmable completion for pathnames
```

As script:

```bash
$ fsfzf.sh # no arguments
$ fsfzf.sh <DIR>
$ fsfzf.sh ~/ # tilde expansions
$ fsfzf.sh .
$ fsfzf.sh bin/ # programmable completion for pathnames
```
