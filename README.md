# p - The simplest pomodoro tool ever

``` bash
$ p

$ p start Doing stuff

$ p
Started: 1m ago - Doing stuff

$ p wait
...
Done

$ p reset
Pomodoro cancelled

$ cat ~/.p

2015-05-06 10:04:20 +0100,'''-',Doing stuff
2015-05-06 10:35:20 +0100,',Doing more stuff

```

## Installation

To install to `~/bin`, paste this into your command line:

``` bash
curl https://raw.githubusercontent.com/chrismdp/p/master/p > ~/bin/p
```
