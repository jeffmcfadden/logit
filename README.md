# Log It!

A very basic logging library that writes numeric data to a logfile.

It was inspired by the logging functionality of `mrtg`, but with the idea that you might want to log any sort of data.

Works well with `graphit` to display the data later.

## Installation

Install it yourself:

    $ gem install logit

## Usage

Just pipe any numeric value to `logit` and include a filename. `logit` will capture the value the story a 2-year history of data points.

    $ cat datapoint | logit -o data.log

## History

`logit` stores a history of data points at various intervals.

*  600 samples at 5m  intervals 
*  600 samples at 30m intervals 
*  600 samples at 2h  intervals
*  600 samples at 1d  intervals

In all `logit` will store over 2 years of data.