# Note Map

The design expects one active switch and one active button. Multiple switches,
multiple buttons, or no selection produce silence.

## Physical Controls

`Bus.v` maps the board inputs into these bus values:

| Physical input | Bus value |
| --- | ---: |
| `sw1` | 64 |
| `sw2` | 32 |
| `sw3` | 16 |
| `sw4` | 8 |
| `sw5` | 4 |
| `sw6` | 2 |
| `sw7` | 1 |
| `btn1` | 8 |
| `btn2` | 4 |
| `btn3` | 2 |
| `btn4` | 1 |

## Switch/Button Matrix

| Switch | `btn1` | `btn2` | `btn3` | `btn4` |
| --- | --- | --- | --- | --- |
| `sw7` | C6 | CS6 | D6 | DS6 |
| `sw6` | GS5 | A5 | AS5 | B5 |
| `sw5` | E5 | F5 | FS5 | G5 |
| `sw4` | C5 | CS5 | D5 | DS5 |
| `sw3` | GS4 | A4 | AS4 | B4 |
| `sw2` | E4 | F4 | FS4 | G4 |
| `sw1` | C4 | CS4 | D4 | DS4 |

## Frequency Table

| Note | Integer frequency used | Divider threshold |
| --- | ---: | ---: |
| C4 | 262 Hz | 95419 |
| CS4 | 277 Hz | 90252 |
| D4 | 294 Hz | 85034 |
| DS4 | 311 Hz | 80385 |
| E4 | 330 Hz | 75757 |
| F4 | 349 Hz | 71633 |
| FS4 | 370 Hz | 67567 |
| G4 | 392 Hz | 63775 |
| GS4 | 415 Hz | 60240 |
| A4 | 440 Hz | 56818 |
| AS4 | 466 Hz | 53648 |
| B4 | 494 Hz | 50607 |
| C5 | 523 Hz | 47801 |
| CS5 | 554 Hz | 45126 |
| D5 | 587 Hz | 42589 |
| DS5 | 622 Hz | 40192 |
| E5 | 659 Hz | 37936 |
| F5 | 698 Hz | 35816 |
| FS5 | 740 Hz | 33783 |
| G5 | 784 Hz | 31887 |
| GS5 | 830 Hz | 30120 |
| A5 | 880 Hz | 28409 |
| AS5 | 932 Hz | 26824 |
| B5 | 988 Hz | 25303 |
| C6 | 1047 Hz | 23877 |
| CS6 | 1109 Hz | 22542 |
| D6 | 1175 Hz | 21276 |
| DS6 | 1245 Hz | 20080 |
