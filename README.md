# `p`: the simplest pomodoro tool ever

`p` uses a simple tracking log file (`~/.p.log` by default) to keep track of your pomodoros and record simple statistics. It's less than 150 lines of pure shell script.

For more information on the pomodoro technique see http://pomodorotechnique.com.

## Installation

To install to `~/bin`, paste this into your command line:

``` bash
curl https://raw.githubusercontent.com/chrismdp/p/master/p > ~/bin/p
chmod +x ~/bin/p
```

## Usage

To start a pomodoro:

```
$ p start Doing stuff
Pomodoro started on "Doing stuff"
```

To check what we're currently doing, just type `p status` (or just `p` with no arguments):

```
$ p
🍅 1m on "Doing stuff"
```

To cancel a pomodoro:

```
$ p cancel
Cancelled. Don't worry: the next Pomodoro will go better!
```

To play a ringing sound (or do any other action) at the end of a pomodoro use a command such as this:

```
$ p wait && afplay ring.wav
🍅 0m 0s on "Doing stuff"

# (Time passes)

🍅 25m 0s on "Doing stuff" completed. Well done!

```

To look at your basic stats, type `p log` or have a look at your `~/.p.log` file. It's in a simple CSV format: 

```
$ p log

2015-05-06 10:04:20 +0100,'''-',Doing stuff
2015-05-06 10:35:20 +0100,',Doing more stuff
```

It should be possible to do some quite interesting statistical analysis. If you come up with anything let me know!

## Limitations

It currently relies on `date` supporting the `-j` option, which may or may not work with your version of `date`. Compatibility patches are welcome, with the aim of supporting as many platforms as possible with the same script.
