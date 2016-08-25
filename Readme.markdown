# Sensu Overview

This is a widget for [Übersicht][] that displays your current warnings, errors and unknown stati from your [Sensu][] instance.

## Details

If the status:
  - is a error, it will be **red**
  - is a warning, it will be **yellow**
  - is unknown, it will be **gray**

## Configuration

Open `index.coffee` and:

- Insert your `SENSU_PASSWORD` AND `SENSU_USERNAME` for HTTP Basic Auth.
- Insert your `SENSU_URL`.

You can optionally configure:
- sorting events by hostname
- show the output of a check
- show the command that's used by a check
- enable blinking for the indicators (per event type)

Here are some images.

![minimal](images/none.png)
![command](images/command.png)
![output](images/output.png)
![all](images/all.png)
