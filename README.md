# `p` is for people who find that other pomodoro tools slow them down.

[![Build Status](https://travis-ci.org/chrismdp/p.svg)](https://travis-ci.org/chrismdp/p)

`p` is the fastest pomodoro tool you've ever used. It uses a simple tracking log file (`~/.p.log` by default) to keep track of your pomodoros and record simple statistics. It's less than 200 lines of pure Shell.

![demo](https://raw.githubusercontent.com/chrismdp/p/master/demo.gif)

For more information on the pomodoro technique see http://pomodorotechnique.com.

## Installation

To install to `~/bin`, paste this into your command line:

``` bash
curl https://raw.githubusercontent.com/chrismdp/p/master/p > ~/bin/p
chmod +x ~/bin/p
```

## Usage

### Controlling the Pomodoro

To start a pomodoro:

```
$ p start Doing stuff
Pomodoro started on "Doing stuff"
```

To check what we're currently doing, just type `p status` (or just `p` with no arguments):

```
$ p
🍅 24:34 on "Doing stuff"
```

To cancel a pomodoro:

```
$ p cancel
Cancelled. Don't worry: the next Pomodoro will go better!
```

### Monitoring the Pomodoro

To play a ringing sound (or do any other action) at the end of a pomodoro use a command such as this:

```
$ p wait && afplay ring.wav
🍅 24:21 on "Doing stuff"

# (Time passes)

🍅 00:00 on "Doing stuff" completed. Well done!

```

To run a script each second you are waiting (to play a ticking sound, for example), pass the command as following arguments to wait:

```
$ p wait afplay tick.wav && afplay ring.wav
```

This command will be run as a seperate process, and started every second. Make sure that it finishes in a timely fashion!

Here are some example sounds you might like:

http://www.freesound.org/people/DrMinky/sounds/174721/
http://www.freesound.org/people/jorickhoofd/sounds/160052/
http://www.freesound.org/people/Benboncan/sounds/77695/

### Continual monitoring

To continually loop, running commands each second a pomodoro is running and each time one finishes, use `p loop`:

```
$ p loop "afplay tick.wav" "afplay ring.wav"
```

Use Ctrl-C to quit this loop.

### Producing statistics

To look at your basic stats, type `p log` or have a look at your `~/.p.log` file. It's in a simple CSV format: 

```
$ p log

2015-05-06 10:04:20 +0100,'''-',Doing stuff
2015-05-06 10:35:20 +0100,',Doing more stuff
```

It should be possible to do some quite interesting statistical analysis. If you come up with anything let me know!

## Credits

Chris Parsons - http://chrismdp.com
