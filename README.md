# p - The simplest pomodoro tool ever

`p` uses a simple tracking log file (`~/.p.log` by default) to keep track of your pomodoros and record simple statistics.

For more information on the pomodoro technique see http://pomodorotechnique.com.

## Installation

To install to `~/bin`, paste this into your command line:

``` bash
curl https://raw.githubusercontent.com/chrismdp/p/master/p > ~/bin/p
```

## Usage

To start a pomodoro:

``` bash
$ p start Doing stuff
```

To check what we're currently doing, just type `p` with no arguments:

``` bash
$ p
🍅  1m on "Doing stuff"
```

To cancel a pomodoro:

``` bash
$ p cancel
Cancelled. Don't worry: the next Pomodoro will go better!
```

To play a ringing sound (or do any other action) at the end of a pomodoro use a command such as this:

``` bash
$ p wait && afplay ring.wave
🍅  1m on "Doing stuff"

(Time passes)

🍅  1m on "Doing stuff" completed

```

To look at your basic stats, simply have a look at your `~/.p.log` file. It's in a simple CSV format:

```
$ cat ~/.p

2015-05-06 10:04:20 +0100,'''-',Doing stuff
2015-05-06 10:35:20 +0100,',Doing more stuff
```
