I've [mentioned before][wget] that I like to show users of my scripts useful
information. This can be a complex progress bar, a simple progress meter, or
it can be an animation to let the user know the script hasn't hung. These
animations are typically called [Throbbers][throbber] are exist purely to tell
the user to continue patiently waiting. Sometimes folks, like met, call
Throbbers Spinners for two reasons. First, a very common throbber animation
type is the spinning wheel. Second, the word throbber sounds oddly sexual, and
sort of creeps me out if I say it too many times in a sentence (Just kidding.
Well, no, not really.)

This tip will show you to create a spinner for your Bash scripts. If you have
a long running process and don't want to try to tell the user approximately
how much of that process is left to run, showing them a spinner is a great
alternative.

### Implementing the Spinner

The throbber, er I mean spinner, is implemented as a loop that shifts a string
during each iteration.

    spinner()
    {
        local pid=$1
        local delay=0.75
        local spinstr='|/-\'
        echo "$pid" > "/tmp/.spinner.pid"
        while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
            local temp=${spinstr#?}
            printf " [%c]  " "$spinstr"
            local spinstr=$temp${spinstr%"$temp"}
            sleep $delay
            printf "\b\b\b\b\b\b"
        done
        printf "    \b\b\b\b"
    }

Let's examine the meat of the tip. First, I remove the first character from
the string and save the remaining characters into a `temp`.

            local temp=${spinstr#?}

Then I use `printf` to output the first character of `spinstr`, which contains
our animation.

            printf " [%c]  " "$spinstr"

Finally, I shift `spinstr` by constructing a new string that contains the
value of `temp` and all characters from `spinstr` that aren't in `temp`.

            local spinstr=$temp${spinstr%"$temp"}

![Bash Spinner Steps 1 and 2][step12]
![Bash Spinner Steps 1 and 2][step34]

### How it Works

When you have a task to run that will take a large (or unknown) amount of time
invoke it in a background subshell like this:

    (a_long_running_task) &

Then, immediately following that invocation, call the spinner and pass it the
PID of the subshell you invoked.

    spinner $!

The `$!` is a [bash internal variable][internal-variable] for the PID of the
last job run in the background. In this case, it will give us the PID of the
bash shell executing our long running task.


### An Example


[internal-variable]: http://tldp.org/LDP/abs/html/internalvariables.html "Bash Internal Variables"
[wget]: /showing-file-download-progress-using-wget.html "Showing File Download Progress using Wget"
[throbber]: http://en.wikipedia.org/wiki/Throbber "Throbbers"
![step12]: /wp-content/uploads/2011/02/bash-spinner-step12.png "Bash Spinner Steps 1 and 2"
![step34]: /wp-content/uploads/2011/02/bash-spinner-step34.png "Bash Spinner Steps 3 and 4"
