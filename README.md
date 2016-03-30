# Log It!

A very basic logging library that writes numeric data to a logfile.

It was inspired by the logging functionality of `mrtg`, but with the idea that you might want to log any sort of data.

Works well with [graphit](https://github.com/jeffmcfadden/graphit) to display the data later.

## Installation

Install it yourself:

    $ gem install specific_install
    $ gem specific_install https://github.com/jeffmcfadden/logit.git

I'm being stubborn about naming this gem something else, and `logit` is already taken on RubyGems.

## Usage

Just pipe any numeric value to `logit` and include a filename. `logit` will capture the value the story a 2-year history of data points.

    $ cat datapoint | logit -o data.log

## Log Format

    unix_timestamp value
    
Example:

    1459380300 3894.0
    1459380000 7894.0
    1459379700 6894.0
    1459379400 6834.0
    1459379100 6234.0
    1459378800 2234.0
    1459378500 1234.0

## History

`logit` stores a history of data points at various intervals.

*  600 samples at 5m  intervals 
*  600 samples at 30m intervals 
*  600 samples at 2h  intervals
*  600 samples at 1d  intervals

In all `logit` will store over 2 years of data.